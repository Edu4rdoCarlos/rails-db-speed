module Mongo
  class ReviewsController < ApplicationController
    def index
      reviews = ReviewService.list_all(params[:book_id])
      render json: reviews, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      review = ReviewService.find(params[:id])
      render json: review, status: :ok
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: 'Review não encontrada' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def create
      review = ReviewService.create(review_params)
      render json: review, status: :created
    rescue Mongoid::Errors::Validations => e
      render json: { errors: e.document.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def update
      review = ReviewService.update(params[:id], review_params)
      render json: review, status: :ok
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: 'Review não encontrada' }, status: :not_found
    rescue Mongoid::Errors::Validations => e
      render json: { errors: e.document.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def destroy
      ReviewService.destroy(params[:id])
      head :no_content
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: 'Review não encontrada' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def review_params
      params.require(:review).permit(:user_id, :book_id, :rating, :comment)
    end
  end
end 