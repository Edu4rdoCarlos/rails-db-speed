class UsersController < ApplicationController
  def index
    users = request.port == 3001 ? PostgresUser.all : User.all
    render json: users, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  def show
    user = request.port == 3001 ? PostgresUser.find(params[:id]) : User.find(params[:id])
    render json: user, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :not_found
  end

  def create
    user = request.port == 3001 ? PostgresUser.new(user_params) : User.new(user_params)
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
    params.require(:user).permit(:name, :email)
  end
end 