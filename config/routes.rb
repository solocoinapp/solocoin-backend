require 'sidekiq/web'
Sidekiq::Web.app_url = '/'

Rails.application.routes.draw do

  # Authenticated routes
  mount Sidekiq::Web => '/sidekiq'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_scope :user do
        post 'signin', to: 'users/sessions#create'
        post '/', to: 'users/registrations#create'
        post 'password', to: 'users/passwords#create'
      end

      resources :callbacks, except: %i[new create edit update destroy] do
        collection do
          post :mobile_login
          post :mobile_sign_up
        end
      end

      resources :users, only: :update
      get 'users/profile', action: :show, controller: 'users'
      resources :notification_tokens, only: :create
      resources :sessions, only: :create
      resource :leaderboard, only: :show
    end
  end
end
