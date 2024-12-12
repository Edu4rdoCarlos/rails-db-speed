class CreatePostgresReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :postgres_reviews do |t|
      t.bigint :user_id, null: false
      t.bigint :book_id, null: false
      t.integer :rating, null: false
      t.text :comment, null: false

      t.timestamps
    end

    add_index :postgres_reviews, :user_id
    add_index :postgres_reviews, :book_id
    add_foreign_key :postgres_reviews, :postgres_users, column: :user_id
    add_foreign_key :postgres_reviews, :postgres_books, column: :book_id
  end
end
