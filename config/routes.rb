Rails.application.routes.draw do
  root "root#index"

  get 'terms' => 'pages#terms', as: :terms
  get 'faq' => 'pages#faq', as: :faq
  resource :demo, only: [:show] do
    get :procon_performance_metric, on: :collection
  end
  resource :user, only: [:new, :edit, :update, :create]
  resources :user_sessions, only: [:new, :create]
  get 'login' => 'user_sessions#new', as: :login
  post 'login' => "user_sessions#create"
  post 'logout' => 'user_sessions#destroy', as: :logout
  resources :saved_buttons_settings, only: [:index, :show, :create, :update, :destroy] do
    member do
      put :update_content
    end

    resources :public_saved_buttons_settings, only: [:create, :destroy]
  end

  resources :remote_macro_groups, only: [] do
    resources :game_softs, only: :index, module: :remote_macro_groups do
      resources :remote_macro_templates, only: :index do
        resources :remote_macros, only: :create
      end
    end
  end

  resources :remote_macro_groups, only: [:show, :edit, :update, :new, :create, :destroy], shallow: true do
    resources :remote_macros, only: [:new, :create, :edit, :update, :destroy] do
      post 'devices/:device_unique_key/test_emit' => 'remote_macros#test_emit', as: :test_emit
      get :edit_trigger_words, on: :member
      patch :update_trigger_words, on: :member
    end
  end

  resources :streaming_services, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    delete :unlink_streaming_service_account, on: :member

    resources :streaming_service_accounts, only: [] do
      resource :monitoring, only: [:create, :destroy], module: :streaming_services
    end

    resources :youtube_live, only: [:new, :show], module: :streaming_services do
      post :commands, on: :member
    end

    resources :twitch, only: [:new, :show], module: :streaming_services do
      post :enqueue, on: :collection # require word param
    end
  end

  namespace :internal do
    resources :procon_bypass_man_versions, only: [:show], constraints: { id: /[^\/]+/ }
  end

  get 'p/:id' => 'public_saved_buttons_settings#show', as: :public_saved_buttons_setting

  resources :devices, only: [:new, :index, :show, :edit, :create] do
    resource :procon_performance_metric, module: :devices, only: :show

    member do
      put :update_name
      post :ping
      post :restart
      post :pbm_upgrade
      post :restore_setting
      post :restore_editable_setting
      get :current_status
      post :offline
    end
  end

  namespace :feature do
    root "root#index"
    namespace :splatoon2 do
      resources :sketches, only: [:index, :new, :show, :edit, :create, :update, :destroy] do
        resource :drawing_sketch, only: [:show, :post]
        member do
          get :edit_binary_threshold
          get :monochrome_image
          get :cropped_monochrome_image
        end
      end
    end
  end

  namespace :api do
    resources :events, only: [:create]

    resources :devices, only: :show do
      resources :procon_performance_metrics, only: [:create]
      resources :pbm_jobs, only: [:index, :update]
      resources :device_statuses, only: [:create]
      resources :completed_pbm_remote_macro_jobs, only: [:create]

      resources :streaming_services, module: :streaming_services, only: [:show] do
        post "pbm_remote_macro_jobs/:word/enqueue" => "pbm_remote_macro_jobs#enqueue", as: :enqueue_pbm_remote_macro_jobs
      end
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

  get '/auth/google_oauth2/callback', to: 'omniauth_callbacks#google_oauth2'
  get '/auth/twitch/callback', to: 'omniauth_callbacks#twitch'
end
