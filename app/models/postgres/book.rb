module Postgres
  class Book < Postgres::ApplicationRecord
    self.table_name = 'postgres_books'
    
    # Campos definidos na migração:
    # t.string :title, null: false
    # t.string :author, null: false
    # t.text :description
    # t.string :genre
    
    has_many :reviews
    
    validates :title, presence: true
    validates :author, presence: true
  end
end 