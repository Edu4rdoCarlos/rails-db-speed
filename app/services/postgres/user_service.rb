module Postgres
  class UserService
    def self.list_all
      User.all
    rescue StandardError => e
      raise e
    end

    def self.find(id)
      User.find(id)
    rescue StandardError => e
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
      raise e
    end
  end
end 