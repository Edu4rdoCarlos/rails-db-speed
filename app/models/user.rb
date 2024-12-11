class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  store_in collection: 'users'
end
