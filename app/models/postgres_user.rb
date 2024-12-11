class PostgresUser < ApplicationRecord
  self.table_name = 'users'
  
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
end 