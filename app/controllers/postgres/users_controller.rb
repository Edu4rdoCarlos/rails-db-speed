module Postgres
  class UsersController < Postgres::ApplicationController
    def index
      start_time = Time.current
      Rails.logger.info "Fetching users from PostgreSQL"
      fetch_start = Time.current
      users = UserService.list_all
      Rails.logger.info "PostgreSQL fetch time: #{(Time.current - fetch_start).round(2)}s"
      Rails.logger.info "Total time: #{(Time.current - start_time).round(2)}s"
      Rails.logger.info "Returning #{users.count} users"
      render json: users, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      user = UserService.find(params[:id])
      render json: user, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    # ...

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