class Book
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :reviews, dependent: :destroy

  field :title, type: String
  field :author, type: String
  field :description, type: String
  field :isbn, type: String

  validates :title, presence: true
  validates :author, presence: true
end
