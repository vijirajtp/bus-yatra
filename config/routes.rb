require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  devise_for :users
  get "home/index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root to: "home#index"

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    root to: 'dashboard#index'
    resources :operators
    resources :bus_routes
    resources :buses do
      resources :seats
    end
    resources :trips do
      resources :trip_seats
    end
  end

  resources :trips, only: [:index, :show] do
    resources :seat_holds, only: [:create]
    resources :bookings, only: [:create, :show, :destroy] do
      collection do
        get :confirm_booking
      end
      member do
        get  :reschedule
        post :perform_reschedule
        get  :cancel
    end
    end
  end

  get "bookings", to: "bookings#index"

end
