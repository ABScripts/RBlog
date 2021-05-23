Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/posts', to: 'posts#index', as: :posts
  post '/posts', to: 'posts#create'
  get '/posts/new', to: 'posts#new', as: :new_post
  get '/posts/:id', to: 'posts#show', as: :post
  get '/posts/:id/edit', to: 'posts#edit', as: :edit_post
  get '/posts/:id/delete', to: 'posts#delete', as: :delete_post
  patch '/posts/:id', to: 'posts#update'
  
  get '/hello', to: 'home#hello'

  root to: redirect('/posts')
end
