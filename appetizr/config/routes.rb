Rails.application.routes.draw do
  root "categories#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :categories, param: :nombre
  resources :restaurants
  
  get '/registrarse', to: 'registrations#new'
  post '/registrarse', to: 'regsitrations#create'
  get '/login', to: 'login#new'
  post '/login', to: 'login#create'
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
