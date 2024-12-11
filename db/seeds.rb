# Limpar dados existentes
puts "Limpando dados..."
Review.delete_all
Book.delete_all
User.delete_all
PostgresUser.delete_all

users_data = [
  { name: 'Maria Silva', email: 'maria@email.com' },
  { name: 'João Santos', email: 'joao@email.com' },
  { name: 'Ana Oliveira', email: 'ana@email.com' },
  { name: 'Pedro Costa', email: 'pedro@email.com' }
]

# Criar usuários no MongoDB
puts "Criando usuários no MongoDB..."
mongo_users = users_data.map do |user|
  User.create!(user)
end

# Criar usuários no PostgreSQL
puts "Criando usuários no PostgreSQL..."
postgres_users = users_data.map do |user|
  PostgresUser.create!(user)
end

puts "Seeds concluídos!"
puts "Usuários MongoDB: #{User.count}"
puts "Usuários PostgreSQL: #{PostgresUser.count}"