module Postgres
  class Review < Postgres::ApplicationRecord
    self.table_name = 'postgres_reviews'
    
    # Campos definidos na migração:
    # t.references :user, null: false
    # t.references :book, null: false
    # t.integer :rating, null: false
    # t.text :comment, null: false
    
    belongs_to :user
    belongs_to :book
    
    validates :rating, presence: true, inclusion: { in: 1..10 }
    validates :comment, presence: true
  end
end 