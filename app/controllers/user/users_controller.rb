# app/controllers/user/users_controller.rb
module User
  class UsersController < ApplicationController
    def index
      if ENV['POSTGRES_SERVER']
        users = PostgresUser.all
      else
        users = User.all
      end
      render json: users, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      if ENV['POSTGRES_SERVER']
        user = PostgresUser.find(params[:id])
      else
        user = User.find(params[:id])
      end
      render json: user, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :not_found
    end

    def create
      if ENV['POSTGRES_SERVER']
        user = PostgresUser.new(user_params)
      else
        user = User.new(user_params)
      end

      if user.save
        render json: user, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def update
      user = User.find(params[:id])
      if user.update(user_params)
        render json: user, status: :ok
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      user = User.find(params[:id])
      user.destroy
      head :no_content
    end

    private

    def user_params
      params.require(:user).permit(:name, :email)
    end
  end
end
