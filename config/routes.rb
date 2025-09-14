Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  root 'events#index'
  resources :events

  namespace :api do
    namespace :v1 do
      resources :events
    end
  end
end
