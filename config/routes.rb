Rails.application.routes.draw do
  root "root#index"

  namespace :api do
    resources :events, only: [:create]

    resources :devices, only: :show do
      resources :pbm_jobs, only: [:index, :update]
      resources :device_statuses, only: [:create]
    end
  end

  namespace :admin do
    resources :events, only: [:index] do
      resources :saved_buttons_settings, only: [:create]
    end

    resources :devices, only: [:index, :show] do
      resources :available_pbm_jobs, only: :index

      namespace :pbm_jobs do
        resources :change_pbm_version, only: :create
        resources :reboot_os, only: :create
        resources :stop_pbm, only: :create
        resources :reload_pbm_setting, only: :create
      end

      resource :device_versions, only: [:show] do
        get :current, on: :member
        post :change_request, on: :member
      end

      resources :saved_buttons_settings, only: [:index, :show]
      resources :pbm_sessions, only: [:index, :show]
    end
  end
end
