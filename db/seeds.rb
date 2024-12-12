require 'faker'

# Configuração para melhor performance
ActiveRecord::Base.logger = nil
ActiveRecord::Base.connection.execute("SET session_replication_role = 'replica';") # Desabilita triggers temporariamente

# Limpar dados PostgreSQL
puts "Limpando dados PostgreSQL..."
Postgres::Review.delete_all
Postgres::Book.delete_all
Postgres::User.delete_all

# Criar 10000 usuários
puts "Criando usuários PostgreSQL..."
users = []
10_000.times do |i|
  users << {
    name: Faker::Name.name,
    email: Faker::Internet.email,
    preferences: [
      Faker::Book.genre,
      Faker::Book.genre,
      Faker::Book.genre
    ].uniq,
    created_at: Time.current,
    updated_at: Time.current
  }
  
  if (i + 1) % 1000 == 0
    Postgres::User.insert_all(users)
    users = []
    puts "Criados #{i + 1} usuários..."
  end
end
Postgres::User.insert_all(users) unless users.empty?

# Criar 10000 livros
puts "\nCriando livros PostgreSQL..."
books = []
10_000.times do |i|
  books << {
    title: "#{Faker::Book.title} #{i}",
    author: Faker::Book.author,
    description: Faker::Lorem.paragraph(sentence_count: 3),
    genre: Faker::Book.genre,
    created_at: Time.current,
    updated_at: Time.current
  }
  
  if (i + 1) % 1000 == 0
    Postgres::Book.insert_all(books)
    books = []
    puts "Criados #{i + 1} livros..."
  end
end
Postgres::Book.insert_all(books) unless books.empty?

# Criar 10000 reviews
puts "\nCriando reviews PostgreSQL..."
reviews = []
user_ids = Postgres::User.pluck(:id)
book_ids = Postgres::Book.pluck(:id)

10_000.times do |i|
  reviews << {
    user_id: user_ids.sample,
    book_id: book_ids.sample,
    rating: rand(1..10),
    comment: Faker::Lorem.paragraph(sentence_count: 2),
    created_at: Time.current,
    updated_at: Time.current
  }
  
  if (i + 1) % 1000 == 0
    Postgres::Review.insert_all(reviews)
    reviews = []
    puts "Criadas #{i + 1} reviews..."
  end
end
Postgres::Review.insert_all(reviews) unless reviews.empty?

# Reabilitar triggers
ActiveRecord::Base.connection.execute("SET session_replication_role = 'origin';")

puts "\nSeeds concluídos!"
puts "PostgreSQL - Usuários: #{Postgres::User.count}"
puts "PostgreSQL - Livros: #{Postgres::Book.count}"
puts "PostgreSQL - Reviews: #{Postgres::Review.count}"