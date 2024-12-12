module Postgres
  class BookService
    def self.list_all(params = {})
      books = Postgres::Book.all
      books = books.where(genre: params[:genre]) if params[:genre].present?
      books = books.where('title ILIKE ?', "%#{params[:title]}%") if params[:title].present?
      books
    rescue StandardError => e
      Rails.logger.error("Error listing PostgreSQL books: #{e.message}")
      raise e
    end

    def self.find(id)
      Postgres::Book.find(id)
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error("Book not found: #{e.message}")
      raise e
    rescue StandardError => e
      Rails.logger.error("Error finding book: #{e.message}")
      raise e
    end

    def self.create(params)
      book = Postgres::Book.new(params)
      if book.save
        book
      else
        raise ActiveRecord::RecordInvalid.new(book)
      end
    rescue StandardError => e
      Rails.logger.error("Error creating book: #{e.message}")
      raise e
    end
  end
end 