module Postgres
  class User < Postgres::ApplicationRecord
    self.table_name = 'postgres_users'
    
    # Campos definidos na migração:
    # t.string :name, null: false
    # t.string :email, null: false
    # t.string :preferences, array: true, default: []
    
    has_many :reviews
    
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
  end
end 