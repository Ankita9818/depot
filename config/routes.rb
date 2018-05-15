Rails.application.routes.draw do

  constraints user_agent: /Firefox/ do
    root 'store#index'
    match '*url', to: redirect('/404'), via: :all
  end

  # post 'admin/reports' => 'admin/reports#index'
  namespace :admin do
    # resources :reports, only: [:index]
    match :reports, via: [:get, :post], action: :index, controller: :reports
    resources :categories do
      member do
        get 'books', action: 'products', constraints: { id: /\d+/ }
        get 'books', to: redirect('store#index')
      end
    end
  end

  # get 'reports/index'

  resources :categories
  get 'admin' => 'admin#index'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  # get 'admin/index'

  # get 'sessions/new'

  # get 'sessions/create'

  # get 'sessions/destroy'

  scope('/users') do
    match 'line_items', to: 'users#line_items', via: [:get, :post]
    get 'orders', to: 'users#orders'
  end

  get 'my-orders' => 'users#orders'
  get 'my-items' => 'users#line_items'

  resources :users
  # resources :books, as: 'products', controller: 'products'
  resources :products, path: :books

  scope '(:locale)' do
    resources :orders
    resources :line_items
    resources :carts
    root 'store#index', as: 'store_index', via: :all
  end
  # get 'store/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
