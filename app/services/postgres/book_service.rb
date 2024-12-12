module Postgres
  class BookService
    def self.list_all(params = {})
      books = Postgres::Book.all
      books = books.where(genre: params[:genre]) if params[:genre].present?
      books = books.where('title ILIKE ?', "%#{params[:title]}%") if params[:title].present?
      books
    rescue StandardError => e
      raise e
    end

    def self.find(id)
      Postgres::Book.find(id)
    rescue StandardError => e
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
      raise e
    end
  end
end 