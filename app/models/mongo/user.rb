module Mongo
  class User
    include Mongoid::Document
    include Mongoid::Timestamps

    # Fields
    field :name, type: String
    field :email, type: String
    field :preferences, type: Array, default: []

    # Relationships
    has_many :reviews, class_name: 'Mongo::Review'

    # Validations
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
  end
end