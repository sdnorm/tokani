# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  resources :checklist_items, only: [:new, :edit, :update, :create, :destroy] do
    member do
      get :interpreter_items
    end
  end
  resources :checklist_types, except: [:destroy]
  resources :pay_rates
  resources :bill_rates
  resources :reports, only: [:index, :create] do
    collection do
      get :financial
      get :fill_rate
    end
    member do
      get :generate_csv
      get :generate_pdf
    end
  end

  resources :process_batches, only: [:index, :new, :create, :show, :destroy] do
    member do
      get :download_pdf
      get :download_csv
      get :download_interpreter_csv
    end
  end

  resources :interpreter_details, except: [:index] do
    collection do
      put :update_languages
    end
  end

  resources :agency_details, only: [:new, :show, :edit, :create, :update]

  get "interpreters/availability"
  get "interpreters/dashboard", to: "interpreters#dashboard", as: "interpreter_dashboard"
  get "interpreters/invitation", to: "interpreters#invitation"
  get "interpreters/my_scheduled"
  get "interpreters/my_scheduled/details", to: "interpreters#my_scheduled_details"
  get "interpreters/my_assigned"
  get "interpreters/my_assigned/details", to: "interpreters#my_assigned_details"
  get "interpreters/profile", to: "interpreters#profile"
  get "interpreters/profile/personal_edit", to: "interpreters#profile_personal_edit"
  get "interpreters/profile/notifications_edit", to: "interpreters#profile_notifications_edit"
  get "interpreters/profile/security_edit", to: "interpreters#profile_security_edit"
  get "interpreters/public/details", to: "interpreters#public_details"
  get "interpreters/time-off", to: "time_offs#index"

  get "dashboard/customer", to: "dashboard#customer"
  get "customers/customer_details", to: "customers#customer_details"
  get "customers/customer_details_edit", to: "customers#customer_details_edit"

  draw :turbo

  # Jumpstart views
  if Rails.env.development? || Rails.env.test?
    mount Jumpstart::Engine, at: "/jumpstart"
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Administrate
  authenticated :user, lambda { |u| u.tokani_admin? || u.admin? } do
    namespace :admin do
      if defined?(Sidekiq)
        require "sidekiq/web"
        mount Sidekiq::Web => "/sidekiq"
      end

      resources :announcements
      resources :users do
        resource :impersonate, module: :user
      end
      resources :connected_accounts
      resources :accounts
      resources :account_users
      resources :agency_details
      resources :customer_details
      resources :requestor_details
      resources :availabilities
      resources :plans
      namespace :pay do
        resources :customers
        resources :charges
        resources :payment_methods
        resources :subscriptions
      end
      root to: "dashboard#show"
    end
    resources :agencies
    post "tokani_agency_creation", to: "agencies#tokani_create", as: "tokani_agency_creation"
  end

  # API routes
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resource :auth
      resource :me, controller: :me
      resource :password
      resources :accounts
      resources :users
      resources :notification_tokens, only: :create
    end
  end

  # User account
  devise_for :users,
    controllers: {
      omniauth_callbacks: "users/omniauth_callbacks",
      registrations: "users/registrations",
      sessions: "users/sessions"
    }
  devise_scope :user do
    get "session/otp", to: "sessions#otp"
  end

  resources :announcements, only: [:index, :show]
  resources :api_tokens
  resources :accounts do
    member do
      patch :switch
    end

    resource :transfer, module: :accounts
    resources :account_users, path: :members
    resources :account_invitations, path: :invitations, module: :accounts do
      member do
        post :resend
      end
    end
  end
  resources :account_invitations

  # Payments
  resource :billing_address
  namespace :payment_methods do
    resource :stripe, controller: :stripe, only: [:show]
  end
  resources :payment_methods
  namespace :subscriptions do
    resource :billing_address
    namespace :stripe do
      resource :trial, only: [:show]
    end
  end
  resources :subscriptions do
    resource :cancel, module: :subscriptions
    resource :pause, module: :subscriptions
    resource :resume, module: :subscriptions
    resource :upcoming, module: :subscriptions

    collection do
      patch :billing_settings
    end

    scope module: :subscriptions do
      resource :stripe, controller: :stripe, only: [:show]
    end
  end
  resources :charges do
    member do
      get :invoice
    end
  end

  resources :agreements, module: :users
  namespace :account do
    resource :password
  end
  resources :notifications, only: [:index, :show]
  namespace :users do
    resources :mentions, only: [:index]
  end
  namespace :user, module: :users do
    resource :two_factor, controller: :two_factor do
      get :backup_codes
      get :verify
    end
    resources :connected_accounts
  end

  namespace :action_text do
    resources :embeds, only: [:create], constraints: {id: /[^\/]+/} do
      collection do
        get :patterns
      end
    end
  end

  scope controller: :static do
    get :about
    get :terms
    get :privacy
    get :pricing
  end

  post :sudo, to: "users/sudo#create"

  match "/404", via: :all, to: "errors#not_found"
  match "/500", via: :all, to: "errors#internal_server_error"

  authenticated :user do
    root to: "dashboard#show", as: :user_root
    # Alternate route to use if logged in users should still see public root
    # get "/dashboard", to: "dashboard#show", as: :user_root
    # resources :accounts do
    resources :appointments do
      get :search
      member do
        get :interpreter_requests

        get :schedule

        get :time_finish
        put :update_time_finish

        patch :status, to: "appointments#update_status"
      end
    end
    resources :customers
    resources :interpreters do
      collection do
        get :search
        get :search_assigned_int
        get :fetch_appointments
        get :public
        get :appointments
        get :filter_appointments
        get :add_availability
        get :update_timezone_view
        get :income
      end
      member do
        get :appointment_details
        get :my_public_details
        get :my_assigned_details
        get :my_scheduled_details
        get :public_details
        post :decline_offered
        post :accept_offered
        post :claim_public
        post :cancel_coverage
        post :time_finish
        patch :update_timezone
        get :availabilities
      end
    end
    resources :requestors
    resources :notification_settings, only: [:index, :create, :update]
    resources :notification_emails, only: [:create, :update]

    get "/dashboard", to: "dashboard#agency", as: :agency_dashboard

    resources :availabilities, only: [:create, :destroy]
    resources :time_offs
    get "/agencies/agency_details", to: "agencies#agency_detail_form", as: :agency_detail_form
    patch "/agencies/agency_details", to: "agencies#agency_detail_update", as: :agency_detail_update
  end

  resources :customer_categories
  resources :recipients
  resources :providers
  resources :requestor_details
  resources :languages do
    member do
      patch :toggle_active
    end
  end
  resources :specialties
  # get "requestor/index"
  resources :sites do
    collection do
      get :dropdown
      get :dropdown_for_reports
      get :departments_dropdown
      get :departments_dropdown_for_reports
      get :select_list
      get :department_select_list
    end
  end

  post "search_interpreters_path", to: "appointments#search_interpreters_path", as: "search_interpreters_path"

  get "agencies/accounting/process_invoices", to: "agencies#account_process_invoices"
  get "agencies/accounting/invoices", to: "agencies#account_invoices"

  # Public marketing homepage
  root to: "static#index"
end
