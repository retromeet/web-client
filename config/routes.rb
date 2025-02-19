# frozen_string_literal: true

Rails.application.routes.draw do
  extend Routes::AuthenticationHelper
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "terms" => "home#terms"
  get "privacy" => "home#privacy"
  get "about" => "home#about"

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  logged_in do
    root to: "listing#show", as: :authenticated_root
  end
  root "home#index"

  resource :listing, only: %i[show], controller: "listing"

  resource :session, only: [], path: :auth do
    delete :destroy, path: :sign_out, as: "destroy"
  end

  get "auth/callback", to: "sessions#create"

  resource :profile, except: %i[new create destroy] do
    resource :location, only: %i[edit update], controller: "profiles/locations" do
      collection do
        get "search"
      end
    end
    resource :picture, only: %i[edit update], controller: "profiles/picture"
    resources :block, only: %i[create destroy], controller: "profiles/blocks"
  end
  get "/profiles/:id", to: "profiles#view", as: :view_profile

  resources :conversations, only: %i[index create] do
    resource :messages, only: %i[show create], controller: "conversations/messages"
  end

  resource :reports, only: %i[create] do
    get "wizard_step1"
    get "wizard_step2"
    get "wizard_step3"
  end
  resources :notification, only: %i[index]

  get "/images/*rest", to: "image_proxy#image"
end
