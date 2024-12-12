module Postgres
  class BooksController < Postgres::ApplicationController
    def index
      start_time = Time.current
      books = Rails.cache.fetch("postgres_books", expires_in: 1.hour) do
        Rails.logger.info "Cache MISS: Fetching books from PostgreSQL"
        fetch_start = Time.current
        result = BookService.list_all(params)
        Rails.logger.info "PostgreSQL fetch time: #{(Time.current - fetch_start).round(2)}s"
        result
      end
      Rails.logger.info "Total time: #{(Time.current - start_time).round(2)}s"
      Rails.logger.info "Returning #{books.count} books"
      render json: books, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      start_time = Time.current
      book = Rails.cache.fetch("postgres_book_#{params[:id]}", expires_in: 1.hour) do
        Rails.logger.info "Cache MISS: Fetching book from PostgreSQL"
        fetch_start = Time.current
        result = BookService.find(params[:id])
        Rails.logger.info "PostgreSQL fetch time: #{(Time.current - fetch_start).round(2)}s"
        result
      end
      Rails.logger.info "Total time: #{(Time.current - start_time).round(2)}s"
      render json: book, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Book not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def create
      book = BookService.create(book_params)
      Rails.cache.delete("postgres_books")  # Invalidate books list cache
      render json: book, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def update
      book = BookService.update(params[:id], book_params)
      Rails.cache.delete("postgres_books")  # Invalidate books list cache
      Rails.cache.delete("postgres_book_#{params[:id]}")  # Invalidate book cache
      render json: book, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Book not found' }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def destroy
      BookService.destroy(params[:id])
      Rails.cache.delete("postgres_books")  # Invalidate books list cache
      Rails.cache.delete("postgres_book_#{params[:id]}")  # Invalidate book cache
      head :no_content
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Book not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def book_params
      params.require(:book).permit(:title, :author, :description, :genre)
    end
  end
end 