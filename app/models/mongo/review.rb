module Mongo
  class Review
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :user, class_name: 'Mongo::User'
    belongs_to :book, class_name: 'Mongo::Book'

    field :id, type: Integer
    field :rating, type: Integer
    field :comment, type: String

    validates :rating, presence: true, inclusion: { in: 1..10 }
    validates :comment, presence: true
  end
end 