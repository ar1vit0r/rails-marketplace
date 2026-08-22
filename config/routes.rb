Rails.application.routes.draw do
  devise_for :users
  root "pages#home"

  resources :products, only: %i[index show]
  resources :categories, only: %i[index show]

  get "cart", to: "cart#show"
  post "cart/add/:product_id", to: "cart#add", as: :cart_add
  delete "cart/remove/:id", to: "cart#remove", as: :cart_remove

  resources :orders, only: %i[create show]

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :products
    resources :categories
  end
end
