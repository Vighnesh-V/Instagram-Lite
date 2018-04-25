Rails.application.routes.draw do
  root 'welcome#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  delete '/comments/:id', to: 'comments#destroy'
  resources :posts do
    member do
      patch 'toggle_like_feed'
      patch 'toggle_like_post'
      patch 'toggle_like_user'
      post 'new_comment_feed'
      post 'new_comment_user'
      post 'new_comment_post'
    end
  end

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
