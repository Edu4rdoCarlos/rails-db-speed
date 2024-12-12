module Mongo
  class UsersController < ApplicationController
    def index
      users = User.all
      render json: users, status: :ok
    rescue StandardError => e
      Rails.logger.error("Erro ao listar usuários Mongo: #{e.message}")
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      user = User.find(params[:id])
      render json: user, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :not_found
    end

    def create
      user = User.new(user_params)
      if user.save
        render json: user, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def user_params
      params.require(:user).permit(:id, :name, :email, preferences: [])
    end
  end
end 