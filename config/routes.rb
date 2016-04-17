Rails.application.routes.draw do
  root 'home#index'

  namespace :account_kit do
    resources :sessions, only: [:new, :create]
  end
end
