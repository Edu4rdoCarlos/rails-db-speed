module Mongo
  class BookService
    def self.list_all(params = {})
      books = Book.all
      books = books.where(genre: params[:genre]) if params[:genre].present?
      books = books.where(title: /#{params[:title]}/i) if params[:title].present?
      books
    rescue StandardError => e
      Rails.logger.error("Error listing MongoDB books: #{e.message}")
      raise e
    end

    def self.find(id)
      Book.find(id)
    rescue Mongoid::Errors::DocumentNotFound => e
      Rails.logger.error("Book not found: #{e.message}")
      raise e
    rescue StandardError => e
      Rails.logger.error("Error finding book: #{e.message}")
      raise e
    end

    def self.create(params)
      book = Book.new(params)
      if book.save
        book
      else
        raise Mongoid::Errors::Validations.new(book)
      end
    rescue StandardError => e
      Rails.logger.error("Error creating book: #{e.message}")
      raise e
    end

    def self.update(id, params)
      book = Book.find(id)
      if book.update(params)
        book
      else
        raise Mongoid::Errors::Validations.new(book)
      end
    rescue StandardError => e
      Rails.logger.error("Error updating book: #{e.message}")
      raise e
    end

    def self.destroy(id)
      book = Book.find(id)
      book.destroy
    rescue StandardError => e
      Rails.logger.error("Error deleting book: #{e.message}")
      raise e
    end
  end
end 