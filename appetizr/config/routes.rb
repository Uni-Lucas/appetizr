Rails.application.routes.draw do
  # Defines the root path route ("/"), categories for now, will be explore (restaurantes#index)
  root "restaurants#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :categories, param: :nombre
  
  resources :restaurants do
    post '/rank', to: 'ranks#create'
    resources :dishes, only: [:show, :new, :create, :edit, :update, :destroy]
  end

  get 'search', to: 'restaurants#search', as: 'search_restaurants'
  get '/restaurants/:id/stats', to: 'restaurants#stats'
  get '/restaurants/:id/edit_info', to: 'restaurants#edit_info'
  
  resources :posts, only: [:new, :create, :destroy] do
    get '/responses', to: 'post_responses#index' 
  end
  resources :reviews, only: [:new, :create, :destroy] do
    get '/responses', to: 'review_responses#index' 
  end
  
  get '/users/mis_restaurantes', to: 'users#mis_restaurantes'
  resources :users, param: :nombre
  post '/users/new', to: 'users#create'
  get '/is_rest_owner', to: 'users#is_restaurant_owner'
  
  get '/login', to: 'logins#new'
  post '/login', to: 'logins#create'
  get '/logout',  to: 'logins#destroy'

  resources :reactions, only: [:create, :update]
  resources :responses, only: [:new, :create, :destroy]
  
  get '/nearme', to: 'nearme#index', as: 'nearme'


  # Error pages
  get '/404', to: 'errors#not_found', via: :all
  get '/500', to: 'errors#internal_server_error', via: :all

  
  # /admin tiene que renderizar la vista admin/dashboard.html.erb
  get '/admin', to: 'admin#dashboard', as: 'admin_dashboard'
  get '/admin/promote', to: 'admin#promote', as: 'admin_promote'
  namespace :admin do
    get 'actualizar_datos', to: 'admin#actualizar_datos'
  end




  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  # root "posts#index"
  match '*unmatched', to: 'errors#not_found', via: :all
end
