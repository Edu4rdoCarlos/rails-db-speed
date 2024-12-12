module Mongo
  class User
    include Mongoid::Document
    include Mongoid::Timestamps

    has_many :reviews, class_name: 'Mongo::Review', dependent: :destroy

    field :name, type: String
    field :email, type: String
    field :id, type: Integer
    field :preferences, type: Array, default: []

    validates :email, presence: true, uniqueness: true
    validates :name, presence: true

    store_in collection: 'users'
  end
end 