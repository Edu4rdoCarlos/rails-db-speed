module Postgres
  class ReviewService
    def self.list_all
      Review.all
    rescue StandardError => e
      raise e
    end

    def self.find(id)
      Review.find(id)
    rescue StandardError => e
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
      raise e
    end
  end
end 