Rails.application.routes.draw do
  resources :posts
  root 'welcome#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/friend_requests', to: 'users#friend_requests'
  resources :users do
    member do
      post 'send_friend_request'
      patch 'accept_friend_request'
      put 'accept_friend_request'
      delete 'delete_friend'
    end
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
