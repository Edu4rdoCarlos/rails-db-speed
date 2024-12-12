module Mongo
  class User
    include Mongoid::Document
    include Mongoid::Timestamps

    # Campos
    field :name, type: String
    field :email, type: String
    field :preferences, type: Array, default: []

    # Relacionamentos
    has_many :reviews, class_name: 'Mongo::Review'

    # Validações
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
  end
end