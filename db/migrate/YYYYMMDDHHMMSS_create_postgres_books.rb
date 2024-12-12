class CreatePostgresBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :postgres_books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.text :description
      t.string :genre

      t.timestamps
    end
  end
end 