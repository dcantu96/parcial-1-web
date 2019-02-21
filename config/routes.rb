Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  post :search, to: "home#show", as: :search

  get 'show', to: 'home#show', as: :show
  get 'search', to: "home#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
