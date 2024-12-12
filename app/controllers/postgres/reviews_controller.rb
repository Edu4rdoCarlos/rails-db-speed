module Postgres
  class ReviewsController < Postgres::ApplicationController
    def index
      start_time = Time.current
      reviews = Rails.cache.fetch("postgres_reviews_#{params[:book_id]}", expires_in: 1.hour) do
        Rails.logger.info "Cache MISS: Fetching reviews from PostgreSQL"
        fetch_start = Time.current
        result = ReviewService.list_all(book_id: params[:book_id])
        Rails.logger.info "PostgreSQL fetch time: #{(Time.current - fetch_start).round(2)}s"
        result
      end
      Rails.logger.info "Total time: #{(Time.current - start_time).round(2)}s"
      Rails.logger.info "Returning #{reviews.count} reviews"
      render json: reviews, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      start_time = Time.current
      review = Rails.cache.fetch("postgres_review_#{params[:id]}", expires_in: 1.hour) do
        Rails.logger.info "Cache MISS: Fetching review from PostgreSQL"
        fetch_start = Time.current
        result = ReviewService.find(params[:id])
        Rails.logger.info "PostgreSQL fetch time: #{(Time.current - fetch_start).round(2)}s"
        result
      end
      Rails.logger.info "Total time: #{(Time.current - start_time).round(2)}s"
      render json: review, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Review not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def create
      review = ReviewService.create(review_params)
      Rails.cache.delete("postgres_reviews_#{review.book_id}")
      Rails.cache.delete("postgres_book_#{review.book_id}")
      render json: review, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def update
      review = ReviewService.update(params[:id], review_params)
      Rails.cache.delete("postgres_reviews_#{review.book_id}")
      Rails.cache.delete("postgres_review_#{params[:id]}")
      Rails.cache.delete("postgres_book_#{review.book_id}")
      render json: review, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Review not found' }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def destroy
      review = ReviewService.find(params[:id])
      book_id = review.book_id
      ReviewService.destroy(params[:id])
      Rails.cache.delete("postgres_reviews_#{book_id}")
      Rails.cache.delete("postgres_review_#{params[:id]}")
      Rails.cache.delete("postgres_book_#{book_id}")
      head :no_content
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Review not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def review_params
      params.require(:review).permit(:user_id, :book_id, :rating, :comment)
    end
  end
end 