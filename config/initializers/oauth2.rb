# frozen_string_literal: true

Rails.application.configure do
  config.x.oauth_client_id = ENV.fetch("OAUTH_CLIENT_ID")
  config.x.oauth_client_secret = ENV.fetch("OAUTH_CLIENT_SECRET")
  config.x.oauth_registration_access_token = ENV.fetch("OAUTH_REGISTRATION_ACCESS_TOKEN")
end
