module Mongo
  class BooksController < ApplicationController
    def index
      start_time = Time.current
      books = Rails.cache.fetch("mongo_books", expires_in: 1.hour) do
        Rails.logger.info "Cache MISS: Fetching books from MongoDB"
        fetch_start = Time.current
        result = BookService.list_all(params).to_a
        Rails.logger.info "MongoDB fetch time: #{(Time.current - fetch_start).round(2)}s"
        result
      end
      Rails.logger.info "Total time: #{(Time.current - start_time).round(2)}s"
      Rails.logger.info "Returning #{books.count} books"
      render json: books, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      book = BookService.find(params[:id])
      render json: book, status: :ok
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: 'Book not found' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def create
      book = BookService.create(book_params)
      render json: book, status: :created
    rescue Mongoid::Errors::Validations => e
      render json: { errors: e.document.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def update
      book = BookService.update(params[:id], book_params)
      render json: book, status: :ok
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: 'Book not found' }, status: :not_found
    rescue Mongoid::Errors::Validations => e
      render json: { errors: e.document.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def destroy
      BookService.destroy(params[:id])
      head :no_content
    rescue Mongoid::Errors::DocumentNotFound
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