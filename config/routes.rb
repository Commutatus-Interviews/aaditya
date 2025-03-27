Rails.application.routes.draw do
  devise_for :users
  root to: 'dashboard#index'
  resources :expenses, only: [:new, :create]
  resources :people, only: [:show]
  post '/settle_up', to: 'settlements#create', as: 'settle_up'
end