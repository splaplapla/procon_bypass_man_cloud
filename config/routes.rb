Rails.application.routes.draw do
  root "root#index"

  namespace :api do
    resources :events, only: [:create]
  end

  namespace :admin do
    resources :events, only: [:index]
  end
end
