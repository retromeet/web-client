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
    get :new, path: :sign_in, as: :new
    post :create, path: :sign_in
    get :new_account, path: :sign_up
    post :create_account, path: :sign_up
    delete :destroy, path: :sign_out, as: "destroy"
  end

  resource :profile, except: %i[new create destroy] do
    resource :location, only: %i[edit update], controller: "profiles/locations" do
      collection do
        get "search"
      end
    end
  end
  get "/profiles/:id", to: "profiles#view", as: :view_profile

  resource :conversations, only: %i[show]
end
