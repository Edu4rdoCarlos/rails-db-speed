module Postgres
  class UsersController < Postgres::ApplicationController
    def index
      start_time = Time.current
      users = Rails.cache.fetch("postgres_users", expires_in: 1.hour) do
        Rails.logger.info "Cache MISS: Fetching users from PostgreSQL"
        fetch_start = Time.current
        result = UserService.list_all
        Rails.logger.info "PostgreSQL fetch time: #{(Time.current - fetch_start).round(2)}s"
        result
      end
      Rails.logger.info "Total time: #{(Time.current - start_time).round(2)}s"
      Rails.logger.info "Returning #{users.count} users"
      render json: users, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      start_time = Time.current
      user = Rails.cache.fetch("postgres_user_#{params[:id]}", expires_in: 1.hour) do
        Rails.logger.info "Cache MISS: Fetching user from PostgreSQL"
        fetch_start = Time.current
        result = UserService.find(params[:id])
        Rails.logger.info "PostgreSQL fetch time: #{(Time.current - fetch_start).round(2)}s"
        result
      end
      Rails.logger.info "Total time: #{(Time.current - start_time).round(2)}s"
      render json: user, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def create
      user = Postgres::UserService.create(user_params)
      Rails.cache.delete("postgres_users")  # Invalidate users list cache
      render json: user, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def update
      user = Postgres::UserService.update(params[:id], user_params)
      Rails.cache.delete("postgres_users")  # Invalidate users list cache
      Rails.cache.delete("postgres_user_#{params[:id]}")  # Invalidate user cache
      render json: user, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def destroy
      UserService.destroy(params[:id])
      Rails.cache.delete("postgres_users")  # Invalidate users list cache
      Rails.cache.delete("postgres_user_#{params[:id]}")  # Invalidate user cache
      head :no_content
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, preferences: [])
    end
  end
end 