Rails.application.routes.draw do

  root :to => 'users#new'
  # resources :users

  namespace :api do
    namespace :v1 do
      post '/sign_in', to: 'users#sign_in'
      post '/data', to: 'uploads#data'
    end
  end

end
