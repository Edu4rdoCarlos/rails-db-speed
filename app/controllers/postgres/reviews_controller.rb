module Postgres
  class ReviewsController < Postgres::ApplicationController
    def index
      begin
        reviews = Postgres::Review.all
        render json: reviews, status: :ok
      rescue => e
        puts "ERRO DETALHADO: #{e.class} - #{e.message}"
        puts e.backtrace
        render json: { error: "#{e.class} - #{e.message}" }, status: :internal_server_error
      end
    end

    def show
      review = Postgres::Review.find(params[:id])
      render json: review, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :not_found
    end

    def create
      review = Postgres::Review.new(review_params)
      if review.save
        render json: review, status: :created
      else
        render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def review_params
      params.require(:review).permit(:user_id, :book_id, :rating, :comment)
    end
  end
end 