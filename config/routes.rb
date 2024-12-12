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
    resources :reviews
  end
end
