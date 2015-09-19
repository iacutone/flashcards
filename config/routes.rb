Rails.application.routes.draw do

  root :to => 'users#new'
  # resources :users

  namespace :api do
    namespace :v1 do
      post '/sign_in', to: 'sessions#sign_in'
      post '/sign_up', to: 'sessions#sign_up'
      post '/data', to: 'uploads#data'
      get 'images', to: 'uploads#images'
    end
  end

end
