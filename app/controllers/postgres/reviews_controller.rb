module Postgres
  class ReviewsController < Postgres::ApplicationController
    def index
      reviews = Postgres::ReviewService.list_all
      render json: reviews, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      review = ReviewService.find(params[:id])
      render json: review, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :not_found
    end

    def create
      review = ReviewService.create(review_params)
      render json: review, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def review_params
      params.require(:review).permit(:user_id, :book_id, :rating, :comment)
    end
  end
end 