Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :applications, only: [:index, :create, :show, :update]
      resources :chats, only: [:index, :create, :show]
      resources :messages, only: [:index, :create, :show, :update]
    end
  end
  # Defines the root path route ("/")
  # root "articles#index"
end