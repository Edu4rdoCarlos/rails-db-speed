module Mongo
  class UsersController < ApplicationController
    def index
      users = UserService.list_all
      render json: users, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      user = UserService.find(params[:id])
      render json: user, status: :ok
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: 'Usuário não encontrado' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def create
      user = UserService.create(user_params)
      render json: user, status: :created
    rescue Mongoid::Errors::Validations => e
      render json: { errors: e.document.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def update
      user = UserService.update(params[:id], user_params)
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