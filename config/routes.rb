Rails.application.routes.draw do

  constraints user_agent: /Firefox/ do
    root 'store#index'
    match '*url', to: redirect('/404'), via: :all
  end

  post 'admin/reports' => 'admin/reports#index'
  namespace :admin do
    resources :reports, only: [:index]
    resources :categories do
      member do
        get 'books', action: 'show_products', constraints: { id: /\d+/ }
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

  get 'my-items' => 'users#line_items'
  get 'my-orders' => 'users#orders'

  scope('/users') do
    get 'line_items', to: 'users#line_items'
    get 'orders', to: 'users#orders'
  end

  resources :users
  resources :books, as: 'products', controller: 'products'

  scope '(:locale)' do
    resources :orders
    resources :line_items
    resources :carts
    root 'store#index', as: 'store_index', via: :all
  end
  # get 'store/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
