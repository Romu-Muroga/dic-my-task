Rails.application.routes.draw do
  root to: "tasks#index"
  resources :users, only: [:new, :create, :show]
  resources :sessions, only: [:new, :create, :destroy]
  resources :tasks do
    get "search", on: :collection
  end
end
