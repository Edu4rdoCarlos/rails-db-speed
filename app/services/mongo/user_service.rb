module Mongo
  class UserService
    def self.list_all
      User.all
    rescue StandardError => e
      Rails.logger.error("Erro ao listar usuários Mongo: #{e.message}")
      raise e
    end

    def self.find(id)
      User.find(id)
    rescue Mongoid::Errors::DocumentNotFound => e
      Rails.logger.error("Usuário não encontrado: #{e.message}")
      raise e
    rescue StandardError => e
      Rails.logger.error("Erro ao buscar usuário: #{e.message}")
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
      Rails.logger.error("Erro ao criar usuário: #{e.message}")
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
      Rails.logger.error("Erro ao atualizar usuário: #{e.message}")
      raise e
    end

    def self.destroy(id)
      user = User.find(id)
      user.destroy
    rescue StandardError => e
      Rails.logger.error("Erro ao deletar usuário: #{e.message}")
      raise e
    end
  end
end 