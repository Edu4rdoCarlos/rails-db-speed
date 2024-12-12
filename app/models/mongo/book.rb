module Mongo
  class Book
    include Mongoid::Document
    include Mongoid::Timestamps

    # Fields
    field :title, type: String
    field :author, type: String
    field :description, type: String
    field :genre, type: String

    # Ratings statistics subdocument
    field :ratings_summary, type: Hash, default: {
      average_rating: 0.0,
      total_ratings: 0,
      rating_distribution: {
        "1" => 0, "2" => 0, "3" => 0, "4" => 0, "5" => 0,
        "6" => 0, "7" => 0, "8" => 0, "9" => 0, "10" => 0
      }
    }

    # Relationships
    has_many :reviews, class_name: 'Mongo::Review'

    # Validations
    validates :title, presence: true
    validates :author, presence: true

    def update_ratings_summary
      reviews_count = reviews.count
      
      if reviews_count > 0
        total = reviews.sum(:rating)
        distribution = reviews.group_by(&:rating).transform_values(&:count)
        
        update(ratings_summary: {
          average_rating: (total.to_f / reviews_count).round(1),
          total_ratings: reviews_count,
          rating_distribution: (1..10).each_with_object({}) { |i, hash| 
            hash[i.to_s] = distribution[i] || 0 
          }
        })
      end
    end
  end
end 