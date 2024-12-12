module Postgres
  class ReviewService
    def self.list_all
      Review.all
    rescue StandardError => e
      Rails.logger.error("Error listing PostgreSQL reviews: #{e.message}")
      raise e
    end

    def self.find(id)
      Review.find(id)
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error("Review not found: #{e.message}")
      raise e
    rescue StandardError => e
      Rails.logger.error("Error finding review: #{e.message}")
      raise e
    end

    def self.create(params)
      review = Review.new(params)
      if review.save
        review
      else
        raise ActiveRecord::RecordInvalid.new(review)
      end
    rescue StandardError => e
      Rails.logger.error("Error creating review: #{e.message}")
      raise e
    end
  end
end 