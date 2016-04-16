Rails.application.routes.draw do
  root 'sessions#new'

  resource :account_kit, only: [:create]
end
