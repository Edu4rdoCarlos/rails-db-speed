module Postgres
  class BooksController < Postgres::ApplicationController
    def index
      books = Postgres::Book.all

      books = books.where(genre: params[:genre]) if params[:genre].present?

      books = books.where('title ILIKE ?', "%#{params[:title]}%") if params[:title].present?

      render json: books, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      book = Postgres::Book.find(params[:id])
      render json: book, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :not_found
    end

    def create
      book = Postgres::Book.new(book_params)
      if book.save
        render json: book, status: :created
      else
        render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def book_params
      params.require(:book).permit(:title, :author, :description, :genre)
    end
  end
end 