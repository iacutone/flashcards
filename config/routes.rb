Rails.application.routes.draw do

  root :to => 'users#new'
  # resources :users

  namespace :api do
    namespace :v1 do
      post '/sign_in', to: 'sessions#sign_in'
      post '/sign_up', to: 'sessions#sign_up'
      post '/data', to: 'uploads#data'
      get 'select_image', to: 'uploads#select_image'
      get 'images', to: 'uploads#images'
      post 'edit_image', to: 'uploads#edit_image'
      post 'hide_image', to: 'uploads#hide_image'
    end
  end

end
