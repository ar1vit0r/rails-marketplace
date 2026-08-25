Rails.application.routes.draw do
  devise_for :users
  root "pages#home"

  resources :products, only: %i[index show]
  resources :categories, only: %i[index show]

  get "cart", to: "cart#show"
  post "cart/add/:product_id", to: "cart#add", as: :cart_add
  delete "cart/remove/:id", to: "cart#remove", as: :cart_remove

  resources :orders, only: %i[create show] do
    resource :checkout, only: %i[create], controller: "checkout"
  end

  get "checkout/success", to: "checkout#success", as: :checkout_success
  get "checkout/cancel", to: "checkout#cancel", as: :checkout_cancel

  post "webhooks/stripe", to: "webhooks#stripe"

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :products
    resources :categories
  end
end
