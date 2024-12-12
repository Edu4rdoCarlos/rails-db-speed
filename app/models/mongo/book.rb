module Mongo
  class Book
    include Mongoid::Document
    include Mongoid::Timestamps

    has_many :reviews, class_name: 'Mongo::Review', dependent: :destroy

    field :title, type: String
    field :author, type: String
    field :description, type: String
    field :genre, type: String
    field :id, type: Integer

    validates :title, presence: true
    validates :author, presence: true
  end
end 