Rails.application.routes.draw do
  root to: 'pages#home'

  resources :suggestions, only: [:index, :update]
  resources :businesses, only: [:show, :new, :create, :edit, :update]

  devise_for :users, controllers: {sessions: "sessions", registrations: "registrations"}

  authenticated :user do
    root 'suggestions#index', as: :authenticated_root
  end

  get '/users', to: 'pages#welcome', as: :user_root # creates user_root_path
  get '/welcome', to: 'pages#welcome'
  get '/assign_business', to: 'pages#assign_business'
  get '/search', to: 'pages#search'
  get '/my_business', to: 'businesses#my_business'
  get '/matched_business', to: 'suggestions#matched_business'
  get '/hail_mary', to: 'suggestions#hail_mary'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
