module Mongo
  class BooksController < ApplicationController
    def index
      books = BookService.list_all(params)
      render json: books, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def show
      book = BookService.find(params[:id])
      render json: book, status: :ok
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: 'Livro não encontrado' }, status: :not_found
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
      render json: { error: 'Livro não encontrado' }, status: :not_found
    rescue Mongoid::Errors::Validations => e
      render json: { errors: e.document.errors.full_messages }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def destroy
      BookService.destroy(params[:id])
      head :no_content
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: 'Livro não encontrado' }, status: :not_found
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def book_params
      params.require(:book).permit(:title, :author, :description, :genre)
    end
  end
end 