Rails.application.routes.draw do
  # Rotas para ambos os bancos de dados
  resources :users
  resources :books do
    resources :reviews
  end
end
