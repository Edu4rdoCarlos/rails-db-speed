module Mongo
  class ReviewsController < ApplicationController
    def index
      start_time = Time.current
      reviews = Rails.cache.fetch("mongo_reviews_#{params[:book_id]}", expires_in: 1.hour) do
        Rails.logger.info "Cache MISS: Fetching reviews from MongoDB"
        fetch_start = Time.current
        result = ReviewService.list_all(params[:book_id])
        Rails.logger.info "MongoDB fetch time: #{(Time.current - fetch_start).round(2)}s"
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
      review = Rails.cache.fetch("mongo_review_#{params[:id]}", expires_in: 1.hour) do
        Rails.logger.info "Cache MISS: Fetching review from MongoDB"
        fetch_start = Time.current
        result = ReviewService.find(params[:id])
        Rails.logger.info "MongoDB fetch time: #{(Time.current - fetch_start).round(2)}s"
        result
      end
      Rails.logger.info "Total time: #{(Time.current - start_time).round(2)}s"
      render json: review, status: :ok
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: 'Review not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def create
      review = ReviewService.create(review_params)
      Rails.cache.delete("mongo_reviews_#{review.book_id}")
      Rails.cache.delete("mongo_book_#{review.book_id}")
      Rails.cache.delete("top_rated_books")
      render json: review, status: :created
    rescue Mongoid::Errors::Validations => e
      render json: { errors: e.document.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def update
      review = ReviewService.update(params[:id], review_params)
      Rails.cache.delete("mongo_reviews_#{review.book_id}")
      Rails.cache.delete("mongo_review_#{params[:id]}")
      Rails.cache.delete("mongo_book_#{review.book_id}")
      Rails.cache.delete("top_rated_books")
      render json: review, status: :ok
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: 'Review not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def destroy
      review = ReviewService.find(params[:id])
      book_id = review.book_id
      ReviewService.destroy(params[:id])
      Rails.cache.delete("mongo_reviews_#{book_id}")
      Rails.cache.delete("mongo_review_#{params[:id]}")
      Rails.cache.delete("mongo_book_#{book_id}")
      Rails.cache.delete("top_rated_books")
      head :no_content
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: 'Review not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def top_rated_books
      start_time = Time.current
      top_books = Rails.cache.fetch("top_rated_books", expires_in: 1.hour) do
        Rails.logger.info "Cache MISS: Fetching top rated books"
        fetch_start = Time.current
        result = ReviewService.top_rated_books
        Rails.logger.info "MongoDB fetch time: #{(Time.current - fetch_start).round(2)}s"
        result
      end
      Rails.logger.info "Total time: #{(Time.current - start_time).round(2)}s"
      render json: top_books, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def review_params
      params.require(:review).permit(:user_id, :book_id, :rating, :comment)
    end
  end
end