Rails.application.routes.draw do
   devise_for :admins,:path => "admin", controllers: {
        sessions: 'admin/sessions',
        passwords:  'admin/passwords',
        registrations: 'admin/registrations'
      }

 get '/admin' => 'admin/homes#top'
     namespace :admin do
       resources :genres
       resources :items
       resources :customers
       resources :orders,only:[:index,:show,:update]
       resources :order_details,only:[:update]
     end
     root to: 'public/homes#top'
     get '/about' => 'public/homes#about'
    scope module: :public do
      delete '/cart_items/destroy_all' => 'cart_items#destroy_all'
      resources :items, only:[:index,:show,:new] do
      end
      resources :cart_items
      post '/orders/session' => 'orders#session_create'
      get '/orders/confirm' => 'orders#confirm'
      post '/orders/confirm' => 'orders#confirm'
      get '/orders/thanks' => 'orders#thanks'
      patch '/customers/is_active' => 'customers#destroy'
      get '/customers/is_active' => 'customers#quit'
      get '/customers/my_page' => 'customers#show'
      resources :orders, only:[:new,:create,:index,:show]
      resource :customers, only:[:edit,:update]
      resources :addresses, only:[:index, :edit, :destroy, :create, :update]
  end
  devise_for :customers, controllers: {
      sessions: 'public/sessions',
      passwords: 'public/passwords',
      registrations: 'public/registrations'
      }
end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
