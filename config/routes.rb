Rails.application.routes.draw do
  root to: 'tasks#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  namespace :admin do
    resources :users
    resources :labels, only: [:index, :new, :create, :edit, :update, :destroy]
  end
  resources :tasks do
    get :search, on: :collection
  end
end
