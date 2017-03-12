Rails.application.routes.draw do
  root to: 'pages#home'

  devise_for :users

  resources :users, only: [:show]
  resources :events
  resources :categories
  resources :profiles, only: [:new, :edit, :create, :update]

  get "about" => "pages#about"

  resources :photos
end
