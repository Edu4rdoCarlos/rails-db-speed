module Mongo
  class UsersController < ApplicationController
    def index
      start_time = Time.current
      users = Rails.cache.fetch("mongo_users", expires_in: 1.hour) do
        Rails.logger.info "Cache MISS: Buscando usuários do MongoDB"
        fetch_start = Time.current
        result = UserService.list_all.to_a
        Rails.logger.info "Tempo de busca no MongoDB: #{(Time.current - fetch_start).round(2)}s"
        result
      end
      Rails.logger.info "Tempo total: #{(Time.current - start_time).round(2)}s"
      Rails.logger.info "Retornando #{users.count} usuários"
      render json: users, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      start_time = Time.current
      user = Rails.cache.fetch("mongo_user_#{params[:id]}", expires_in: 1.hour) do
        Rails.logger.info "Cache MISS: Buscando usuário #{params[:id]} do MongoDB"
        fetch_start = Time.current
        result = UserService.find(params[:id])
        Rails.logger.info "Tempo de busca no MongoDB: #{(Time.current - fetch_start).round(2)}s"
        result
      end
      Rails.logger.info "Tempo total: #{(Time.current - start_time).round(2)}s"
      render json: user, status: :ok
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: 'Usuário não encontrado' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def create
      user = UserService.create(user_params)
      Rails.cache.delete("mongo_users")  # Invalida o cache da listagem
      render json: user, status: :created
    rescue Mongoid::Errors::Validations => e
      render json: { errors: e.document.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def update
      user = UserService.update(params[:id], user_params)
      Rails.cache.delete("mongo_users")  # Invalida o cache da listagem
      Rails.cache.delete("mongo_user_#{params[:id]}")  # Invalida o cache do usuário
      render json: user, status: :ok
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: 'Usuário não encontrado' }, status: :not_found
    rescue Mongoid::Errors::Validations => e
      render json: { errors: e.document.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def destroy
      UserService.destroy(params[:id])
      Rails.cache.delete("mongo_users")  # Invalida o cache da listagem
      Rails.cache.delete("mongo_user_#{params[:id]}")  # Invalida o cache do usuário
      head :no_content
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: 'Usuário não encontrado' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, preferences: [])
    end
  end
end 