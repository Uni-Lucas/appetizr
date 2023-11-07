Rails.application.routes.draw do
  # Defines the root path route ("/"), categories for now, will be explore (restaurantes#index)
  root "categories#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :categories, param: :nombre
  resources :restaurants do
    resources :dishes, only: [:show, :new, :create, :edit, :update]
  end
  get 'search', to: 'restaurants#search', as: 'search_restaurants'
  get '/restaurants/:id/stats', to: 'restaurants#stats'
  get '/restaurants/:id/edit_info', to: 'restaurants#edit_info'
  resources :posts, only: [:new, :create] do
    get '/responses', to: 'post_responses#index' 
  end
  resources :reviews, only: [:new, :create] do
    get '/responses', to: 'review_responses#index' 
  end
  resources :users
  get '/users/:nombre', to: 'users#show'
  post '/users/new', to: 'users#create'
  
  get '/login', to: 'logins#new'
  post '/login', to: 'logins#create'
  get '/logout',  to: 'logins#destroy'

  resources :reactions, only: [:create, :update]
  resources :responses, only: [:new, :create]


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  # root "posts#index"
end
