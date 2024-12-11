class Review
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :book

  field :rating, type: Integer
  field :comment, type: String

  validates :rating, presence: true, inclusion: { in: 1..10 }
  validates :comment, presence: true
end
