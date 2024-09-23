# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "profile#index"

  resource :session, only: [], path: :auth do
    get :new, path: :sign_in, as: :new
    post :create, path: :sign_in
    get :new_account, path: :sign_up
    post :create_account, path: :sign_up
    match :destroy, path: :sign_out, as: "destroy", via: :delete
  end
end
