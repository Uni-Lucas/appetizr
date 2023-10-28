Rails.application.routes.draw do
  root "categories#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :categories, param: :nombre
  resources :restaurants
  resources :posts, only: [:new, :create]
  
  get '/register', to: 'registrations#new'
  post '/register', to: 'registrations#create'
  get '/login', to: 'logins#new'
  post '/login', to: 'logins#create'
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resource :register, only: [:new, :create]
  # Defines the root path route ("/")
  # root "posts#index"
end
