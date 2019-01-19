Rails.application.routes.draw do
  root to: "tasks#index"
  namespace :admin do
    resources :users
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :tasks do
    get "search", on: :collection
  end
end
