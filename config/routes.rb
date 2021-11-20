Rails.application.routes.draw do
  root "root#index"

  namespace :api do
    resources :events, only: [:create]
  end

  namespace :admin do
    resources :events, only: [:index]
    resources :devices, only: [:index, :show] do
      resources :pbm_sessions, only: [:index, :show] do
      end
    end
  end
end
