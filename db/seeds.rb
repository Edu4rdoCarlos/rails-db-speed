require 'faker'
require 'benchmark'

TOTAL_RECORDS = 30_000

# Configuration for better performance
ActiveRecord::Base.logger = nil
ActiveRecord::Base.connection.execute("SET session_replication_role = 'replica';")

puts "\n=== Starting PostgreSQL seed ==="
postgres_time = Benchmark.measure do
  # Clean PostgreSQL data
  puts "Cleaning PostgreSQL data..."
  Postgres::Review.delete_all
  Postgres::Book.delete_all
  Postgres::User.delete_all

  # Create users
  puts "Creating #{TOTAL_RECORDS} PostgreSQL users..."
  users = []
  TOTAL_RECORDS.times do |i|
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
    
    if (i + 1) % 5000 == 0
      Postgres::User.insert_all(users)
      users = []
      puts "Created #{i + 1} users..."
    end
  end
  Postgres::User.insert_all(users) unless users.empty?

  # Create books
  puts "\nCreating #{TOTAL_RECORDS} PostgreSQL books..."
  books = []
  TOTAL_RECORDS.times do |i|
    books << {
      title: "#{Faker::Book.title} #{i}",
      author: Faker::Book.author,
      description: Faker::Lorem.paragraph(sentence_count: 3),
      genre: Faker::Book.genre,
      created_at: Time.current,
      updated_at: Time.current
    }
    
    if (i + 1) % 5000 == 0
      Postgres::Book.insert_all(books)
      books = []
      puts "Created #{i + 1} books..."
    end
  end
  Postgres::Book.insert_all(books) unless books.empty?

  # Create reviews
  puts "\nCreating #{TOTAL_RECORDS} PostgreSQL reviews..."
  reviews = []
  user_ids = Postgres::User.pluck(:id)
  book_ids = Postgres::Book.pluck(:id)

  TOTAL_RECORDS.times do |i|
    reviews << {
      user_id: user_ids.sample,
      book_id: book_ids.sample,
      rating: rand(1..10),
      comment: Faker::Lorem.paragraph(sentence_count: 2),
      created_at: Time.current,
      updated_at: Time.current
    }
    
    if (i + 1) % 5000 == 0
      Postgres::Review.insert_all(reviews)
      reviews = []
      puts "Created #{i + 1} reviews..."
    end
  end
  Postgres::Review.insert_all(reviews) unless reviews.empty?
end

# Re-enable triggers
ActiveRecord::Base.connection.execute("SET session_replication_role = 'origin';")

puts "\n=== Starting MongoDB seed ==="
mongo_time = Benchmark.measure do
  # Clean MongoDB data
  puts "Cleaning MongoDB data..."
  Mongo::Review.delete_all
  Mongo::Book.delete_all
  Mongo::User.delete_all

  # Create MongoDB users
  puts "Creating #{TOTAL_RECORDS} MongoDB users..."
  mongo_users = []
  TOTAL_RECORDS.times do |i|
    mongo_users << Mongo::User.create!(
      name: Faker::Name.name,
      email: Faker::Internet.unique.email,
      preferences: [
        Faker::Book.genre,
        Faker::Book.genre,
        Faker::Book.genre
      ].uniq
    )
    puts "Created #{i + 1} MongoDB users..." if (i + 1) % 5000 == 0
  end

  # Create MongoDB books
  puts "\nCreating #{TOTAL_RECORDS} MongoDB books..."
  mongo_books = []
  TOTAL_RECORDS.times do |i|
    mongo_books << Mongo::Book.create!(
      title: "#{Faker::Book.title} #{i}",
      author: Faker::Book.author,
      description: Faker::Lorem.paragraph(sentence_count: 3),
      genre: Faker::Book.genre
    )
    puts "Created #{i + 1} MongoDB books..." if (i + 1) % 5000 == 0
  end

  # Create MongoDB reviews
  puts "\nCreating #{TOTAL_RECORDS} MongoDB reviews..."
  TOTAL_RECORDS.times do |i|
    Mongo::Review.create!(
      user: mongo_users.sample,
      book: mongo_books.sample,
      rating: rand(1..10),
      comment: Faker::Lorem.paragraph(sentence_count: 2)
    )
    puts "Created #{i + 1} MongoDB reviews..." if (i + 1) % 5000 == 0
  end
end

puts "\n=== Final Results ==="
puts "PostgreSQL:"
puts "  Users: #{Postgres::User.count}"
puts "  Books: #{Postgres::Book.count}"
puts "  Reviews: #{Postgres::Review.count}"
puts "  Total time: #{postgres_time.real.round(2)} seconds"

puts "\nMongoDB:"
puts "  Users: #{Mongo::User.count}"
puts "  Books: #{Mongo::Book.count}"
puts "  Reviews: #{Mongo::Review.count}"
puts "  Total time: #{mongo_time.real.round(2)} seconds"