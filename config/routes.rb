Rails.application.routes.draw do
  resources :scores
  resources :skills
  namespace :admin do
      resources :users
      root to: "users#index"
    end
  root to: 'users#index'
  devise_for :users
  resources :users
  resources :user_profiles
end
