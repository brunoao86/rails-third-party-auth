Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  get 'signout', to: 'sessions#destroy', as: 'signout'
  get 'login', to: 'sessions#new', as: 'login'

  resources :sessions, only: [:new, :create, :destroy]
  resource :home, only: [:index]

  root to: 'home#index'
end
