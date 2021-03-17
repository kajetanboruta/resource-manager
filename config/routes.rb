Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :tags
    end
  end

  namespace :api do
    namespace :v1 do
      jsonapi_resources :leads
    end
  end
  namespace :api do
    namespace :v1 do
      jsonapi_resources :resources
    end
  end
end
