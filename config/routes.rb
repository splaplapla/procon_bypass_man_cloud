Rails.application.routes.draw do
  root "root#index"

  namespace :api do
    resources :events, only: [:create]
  end
end
