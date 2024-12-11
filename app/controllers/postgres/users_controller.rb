module Postgres
  class UsersController < ApplicationController
    def index
      users = PostgresUser.all
      render json: users, status: :ok
    end

    def show
      user = PostgresUser.find(params[:id])
      render json: user, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Usuário não encontrado' }, status: :not_found
    end

    def create
      user = PostgresUser.new(user_params)
      if user.save
        render json: user, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email)
    end
  end
end 