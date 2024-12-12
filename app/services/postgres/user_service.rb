module Postgres
  class UserService
    def self.list_all
      User.all
    rescue StandardError => e
      Rails.logger.error("Error listing PostgreSQL users: #{e.message}")
      raise e
    end

    def self.find(id)
      User.find(id)
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error("User not found: #{e.message}")
      raise e
    rescue StandardError => e
      Rails.logger.error("Error finding user: #{e.message}")
      raise e
    end

    def self.create(params)
      user = User.new(params)
      if user.save
        user
      else
        raise ActiveRecord::RecordInvalid.new(user)
      end
    rescue StandardError => e
      Rails.logger.error("Error creating user: #{e.message}")
      raise e
    end
  end
end 