Rails.application.routes.draw do
  # Rotas PostgreSQL
  namespace :postgres do
    resources :users
    resources :books do
      resources :reviews
    end
    resources :reviews
  end

  # Rotas MongoDB
  namespace :mongo do
    resources :users
    resources :books do
      resources :reviews
    end
    resources :reviews do
      collection do
        get 'top-rated-books', to: 'reviews#top_rated_books'
      end
    end
  end
end