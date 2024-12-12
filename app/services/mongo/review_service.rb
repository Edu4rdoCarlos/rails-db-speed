module Mongo
  class ReviewService
    def self.list_all(book_id = nil)
      reviews = book_id ? Book.find(book_id).reviews : Review.all
      reviews
    rescue StandardError => e
      Rails.logger.error("Error listing MongoDB reviews: #{e.message}")
      raise e
    end

    def self.find(id)
      Review.find(id)
    rescue Mongoid::Errors::DocumentNotFound => e
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
        raise Mongoid::Errors::Validations.new(review)
      end
    rescue StandardError => e
      Rails.logger.error("Error creating review: #{e.message}")
      raise e
    end

    def self.update(id, params)
      review = Review.find(id)
      if review.update(params)
        review
      else
        raise Mongoid::Errors::Validations.new(review)
      end
    rescue StandardError => e
      Rails.logger.error("Error updating review: #{e.message}")
      raise e
    end

    def self.top_rated_books
      Review.collection.aggregate([
        { "$match" => { "rating" => { "$gte" => 8.5, "$lte" => 10 } } },  
        { "$group" => { 
          "_id" => "$book_id", 
          "average_rating" => { "$avg" => "$rating" },
          "total_reviews" => { "$sum" => 1 }
        }},
        { "$match" => { "total_reviews" => { "$gte" => 1 } } }, 
        { "$sort" => { "average_rating" => -1 } },
      ]).map do |book|
        {
          book_id: book["_id"],
          average_rating: book["average_rating"].round(2),
          total_reviews: book["total_reviews"]
        }
      end
    end

    def self.destroy(id)
      review = Review.find(id)
      review.destroy
    rescue StandardError => e
      Rails.logger.error("Error deleting review: #{e.message}")
      raise e
    end
  end
end