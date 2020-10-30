Rails.application.routes.draw do
  root "pages#home"

  devise_for :users,
    path: "",
    path_names: { sign_in: "login", sign_out: "logout", edit: "profile", sign_up: "registration" },
    controllers: { omniauth_callbacks: "omniauth_callbacks", registrations: "registrations", confirmations: "confirmations" }

  devise_scope :user do
    get "/auth/stripe_connect/callback" => "omniauth_callbacks#stripe_connect"
    get "/signup" => redirect("/registration", status: 301)
    get "/become_a_host" => redirect("/become-a-host", status: 301)
    get "/space_requests" => redirect("/space-requests", status: 301)
  end

  resources :users, only: [:show] do
    member do
      post "/verify_phone_number" => "users#verify_phone_number"
      patch "/update_phone_number" => "users#update_phone_number"
      post "/assign_referral" => "users#assign_referral_code"
      post "/reminder_email" => "users#reminder_email"
      post "/renter_info" => "users#renter_info"
    end

    resources :avatars, only: [:create, :destroy]
  end

  resources :spaces, except: [:edit] do
    member do
      get "listing"
      get "pricing"
      get "pricing_hourly"
      get "pricing_daily"
      get "description"
      get "photo_upload"
      get "amenities"
      get "location"
      get "payout"
      get "payout_confirmed"
      get "preload"
      get "preview"
    end

    resource :favourite, module: :spaces

    resources :photos, only: [:create, :destroy] do
      collection do
        put :sort
      end
    end

    resources :reservations, only: [:create]
    resources :calendars
  end

  resources :guest_reviews, only: [:create, :destroy]
  resources :host_reviews, only: [:create, :destroy]

  # resources :prices, only: [:create, :destroy]

  get "/checkout/:reservation_id", to: "spaces#checkout", as: "checkout"
  get "/use_default_card/:reservation_id", to: "spaces#use_default_card", as: "use_default_card"
  post "/add_payment/:reservation_id", to: "spaces#add_card"
  get "/details/:reservation_id", to: "spaces#details", as: "details"
  patch "/reservations/:reservation_id", to: "spaces#details_update"
  get "/review/:reservation_id", to: "spaces#reservation_review", as: "reservation_review"
  patch "/users/:id", to: "users#update"
  get "/complete/:reservation_id", to: "spaces#reservation_complete", as: "reservation_complete"

  get "/your_trips" => "reservations#your_trips"
  get "/bookings" => "reservations#bookings"
  get "/favourites", to: "spaces/favourites#index", as: "favourites"

  get "search" => "pages#search"
  get "search:query" => "pages#search"

  get "how_it_works" => "pages#how_it_works"
  get "resources", to: "pages#resources"
  get "about" => "pages#about"
  get "become-a-host" => "pages#become_a_host"
  get "faq" => "pages#faq"

  get "/feature_me/:email", to: "pages#feature_me", constraints: { email: /[^\/]+/ }, as: "feature_me"

  get "planning" => "pages#planning"
  get "ambassador" => "pages#ambassador"
  get "hiring" => "pages#hiring"
  get "investing" => "pages#investing"

  get "terms" => "pages#terms"
  get "privacy" => "pages#privacy"

  get "contact" => "contacts#new"

  #<!-- upSpace v2 -->

  get "dashboard" => "dashboards#index"
  get "/dashboard/:user_type" => "dashboards#update_user_type"

  get "admin" => "admin#index"
  get "admin_users" => "admin#admin_users"
  get "admin_spaces" => "admin#admin_spaces"
  get "admin_reservations" => "admin#admin_reservations"
  get "admin_email" => "admin#admin_email"
  get "send_test_user_welcome_email" => "admin#send_test_user_welcome_email"
  get "send_test_lister_welcome_email" => "admin#send_test_lister_welcome_email"
  get "send_test_user_confirmation_email" => "admin#send_test_user_confirmation_email"
  get "send_test_lister_review_request_email" => "admin#send_test_lister_review_request_email"
  get "send_test_renter_review_request_email" => "admin#send_test_renter_review_request_email"
  get "send_test_lister_booking_reminder_email" => "admin#send_test_lister_booking_reminder_email"
  get "send_test_renter_booking_reminder_email" => "admin#send_test_renter_booking_reminder_email"

  resources :space_requests
  get "/space-requests" => "space_requests#index"

  resources :reservations, only: [:approve, :decline] do
    member do
      post "/approve" => "reservations#approve"
      post "/decline" => "reservations#decline"
      post "/cancel" => "reservations#cancel"
    end
  end

  resources :reservations, only: [:show] do
  end

  resources :revenues, only: [:index]

  resources :conversations, only: [:index, :create] do
    resources :messages, only: [:index, :create]
  end

  get "/new_user_created" => "users#created"
  get "/new_user_confirmed" => "users#confirmed"
  get "/host_calendar" => "calendars#host"
  get "/payment_method" => "users#payment"
  get "/payout_method" => "users#payout"
  post "/add_card" => "users#add_card"

  get "/notification_settings" => "settings#edit"
  post "/notification_settings" => "settings#update"

  get "/notifications" => "notifications#index"

  resources "contacts", only: [:new, :create]

  mount ActionCable.server => "/cable"
end
