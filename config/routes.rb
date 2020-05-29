require 'sidekiq/web'
Sidekiq::Web.app_url = '/'

Rails.application.routes.draw do
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # Authenticated routes
  mount Sidekiq::Web => '/sidekiq'
  root to: redirect('/admin')

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

      resource :home, only: :index
      resource :user, only: :update do
        get :profile, to: 'users#show'
        post :redeem_rewards
        get :badges
      end
      resources :notification_tokens, only: :create
      resources :user_questions_answers, only: :create
      resources :rewards_sponsors, only: :index
      post '/sessions/ping', to: 'sessions#ping'
      resource :leaderboard, only: :show
      get '/questions/daily', to: 'questions#daily'
      get '/questions/weekly', to: 'questions#weekly'
    end
  end
end
