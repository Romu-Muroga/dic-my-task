Rails.application.routes.draw do
  root to: "tasks#index"
  namespace :admin do
    resources :users
    resources :labels, only: [:index, :new, :create, :edit, :update, :destroy]
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :tasks do
    get "search", on: :collection
  end
end
