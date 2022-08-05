Rails.application.routes.draw do
  root 'static_page#home'
  resources :users
  resources :account_activations, only: [:edit]
  get '/signup', to: 'users#new'
  get '/help', to: 'static_page#help'
  get '/about', to: 'static_page#about'
  get '/contact', to: 'static_page#contact'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end