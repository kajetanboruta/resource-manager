require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq" # mount Sidekiq::Web in your Rails app
  namespace :api do
    namespace :v1 do
      jsonapi_resources :tags

      resources :tags_export, only: :create
      resources :contacts_form, only: :create
    end
  end
end
