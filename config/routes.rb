Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: 'inflows#index' 

  resources :notifications, :outflows, :reminders, :suppliers, :supply_product_links
  resources :inflows do
    collection do
      get '/expand/:id', to: 'inflows#expand', as: :expand
      post 'add_items/:id', to: 'inflows#add_items', as: :add_items
    end
  end
  resources :products, :supplies do
    collection do
      get 'mass_stock'
      post 'mass_stock_update'
    end
  end
  get 'statistics', to: 'pages#statistics', as: :statistics
  get 'take', to: 'pages#register', as: :register
end
