# frozen_string_literal: true

if ENV["OAUTH_CLIENT_ID"]
  Rails.application.configure do
    config.x.oauth_client_id = ENV.fetch("OAUTH_CLIENT_ID")
    config.x.oauth_client_secret = ENV.fetch("OAUTH_CLIENT_SECRET")
    config.x.oauth_registration_access_token = ENV.fetch("OAUTH_REGISTRATION_ACCESS_TOKEN")
  end
else
  Rails.logger.warn { "No OAUTH config was found. It is fine if you're generating it, but otherwise things will not work!" }
end
