module Postgres
  class BooksController < Postgres::ApplicationController
    def index
      books = Postgres::BookService.list_all(params)
      render json: books, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      book = Postgres::BookService.find(params[:id])
      render json: book, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :not_found
    end

    def create
      book = Postgres::BookService.create(book_params)
      render json: book, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def book_params
      params.require(:book).permit(:title, :author, :description, :genre)
    end
  end
end 