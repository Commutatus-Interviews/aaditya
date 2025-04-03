Rails.application.routes.draw do
  devise_for :users
  root "dashboard#index"

  resources :expenses, only: [:new, :create, :index]
  resources :payments, only: [:new, :create]
  resources :people, only: [:show]  # Friend page
end
