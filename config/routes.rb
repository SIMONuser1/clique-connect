Rails.application.routes.draw do
  resources :suggestions, only: [:index, :update]

  resources :businesses
  devise_for :users
  root to: 'pages#home'

  get '/welcome', to: 'pages#welcome'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
