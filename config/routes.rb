require 'sidekiq/web'

Rails.application.routes.draw do
  default_url_options host: 'www.example.com'
  mount Sidekiq::Web => '/sidekiq' # mount Sidekiq::Web in your Rails app
  namespace :api do
    namespace :v1 do
      resources :tags

      resources :tags_export, only: :create
      resources :contacts_form, only: :create
    end
  end
end
