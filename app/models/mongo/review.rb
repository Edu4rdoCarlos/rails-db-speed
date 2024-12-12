module Mongo
  class Review
    include Mongoid::Document
    include Mongoid::Timestamps

    # Basic fields
    field :rating, type: Integer
    field :comment, type: String

    # References
    belongs_to :user, class_name: 'Mongo::User'
    belongs_to :book, class_name: 'Mongo::Book'

    # Validations
    validates :rating, presence: true, inclusion: { in: 1..10 }
    validates :comment, presence: true
    validates :user, presence: true
    validates :book, presence: true

    # Callbacks to update book statistics
    after_save :update_book_stats
    after_destroy :update_book_stats

    private

    def update_book_stats
      book.update_ratings_summary if book.present?
    end
  end
end 