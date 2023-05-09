# frozen_string_literal: true

Rails.application.routes.draw do
  resources :habits do
    resources :tasks
  end
  resources :users
  post '/auth/login', to: 'authentication#login'
  get 'up' => 'health_check#show'
end
