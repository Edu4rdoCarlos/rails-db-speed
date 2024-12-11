class Review::ReviewsController < ApplicationController
  def index
    reviews = Review.all
    render json: reviews
  end

  def show
    review = Review.find(params[:id])
    render json: review
  end

  def create
    review = Review.new(review_params)
    if review.save
      render json: review, status: :created
    else
      render json: { errors: review.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:name, :email, :preferences)
  end
end
