Rails.application.routes.draw do
  root "devices#index"

  resources :users
  resources :user_sessions, only: [:new, :create, :destroy]
  get 'login' => 'user_sessions#new', as: :login
  post 'login' => "user_sessions#create"
  post 'logout' => 'user_sessions#destroy', as: :logout
  resources :saved_buttons_settings, only: [:index, :show, :create, :update, :destroy] do
    member do
      put :update_content
    end
  end

  resources :devices, only: [:index, :show, :edit] do
    member do
      put :update_name
      post :ping
      post :restart
      post :pbm_upgrade
      post :restore_setting
      get :current_status
    end
  end

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
    resources :saved_buttons_settings, only: [:index, :update, :destroy]

    resources :devices, only: [:index, :show] do
      resources :available_pbm_jobs, only: :index

      resources :pbm_jobs, only: [], shallow: true do
        resources :cancellation_pbm_jobs, only: :create
      end
      namespace :pbm_jobs do
        resources :change_pbm_version, only: :create
        resources :reboot_os, only: :create
        resources :stop_pbm, only: :create
        resources :reload_pbm_setting, only: :create
        resources :restore_pbm_setting, only: :create
      end

      resource :device_versions, only: [:show] do
        get :current, on: :member
        post :change_request, on: :member
      end

      resources :pbm_sessions, only: [:index, :show]

      namespace :saved_buttons_settings, shallow: true do
        resources :contents, only: [:edit, :update]
      end
    end
  end
end
