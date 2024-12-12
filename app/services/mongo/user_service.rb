module Mongo
  class UserService
    def self.list_all
      User.all
    rescue StandardError => e
      Rails.logger.error("Error listing MongoDB users: #{e.message}")
      raise e
    end

    def self.find(id)
      User.find(id)
    rescue Mongoid::Errors::DocumentNotFound => e
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
        raise Mongoid::Errors::Validations.new(user)
      end
    rescue StandardError => e
      Rails.logger.error("Error creating user: #{e.message}")
      raise e
    end

    def self.update(id, params)
      user = User.find(id)
      if user.update(params)
        user
      else
        raise Mongoid::Errors::Validations.new(user)
      end
    rescue StandardError => e
      Rails.logger.error("Error updating user: #{e.message}")
      raise e
    end

    def self.destroy(id)
      user = User.find(id)
      user.destroy
    rescue StandardError => e
      Rails.logger.error("Error deleting user: #{e.message}")
      raise e
    end
  end
end 