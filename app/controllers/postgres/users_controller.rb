module Postgres
  class UsersController < Postgres::ApplicationController
    def index
      users = Postgres::UserService.list_all
      render json: users, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      user = Postgres::UserService.find(params[:id])
      render json: user, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :not_found
    end

    def create
      user = Postgres::UserService.create(user_params)
      render json: user, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, preferences: [])
    end
  end
end 