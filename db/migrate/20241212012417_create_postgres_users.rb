class CreatePostgresUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :postgres_users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :preferences, array: true, default: []

      t.timestamps
    end
    add_index :postgres_users, :email, unique: true
  end
end
