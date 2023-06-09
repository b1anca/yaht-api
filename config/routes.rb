# frozen_string_literal: true

Rails.application.routes.draw do
  resources :habits do
    resources :tasks
    resources :notes, only: %i[index create]
  end
  resources :users, path: '/users/me', only: :none do
    collection do
      get '/' => 'users#me', as: :me
    end
  end
  resources :users do
    resources :notes, only: %i[index create]
  end
  post '/auth/login', to: 'authentication#login'
  get 'up' => 'health_check#show'
end
