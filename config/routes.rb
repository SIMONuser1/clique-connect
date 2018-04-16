Rails.application.routes.draw do
  root to: 'pages#home'

  resources :suggestions, only: [:index, :update]
  resources :businesses

  devise_for :users

  authenticated :user do
    root 'suggestions#index', as: :authenticated_root
  end

  get '/users', to: 'pages#welcome', as: :user_root # creates user_root_path
  get '/welcome', to: 'pages#welcome'
  get '/assign_business', to: 'pages#assign_business'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
