# frozen_string_literal: true

# Adds functionality to authorize a user from controller tests
module ControllerAuthorizationHelper
  # Sets the authorization token using a fake test token
  def set_authorization_headers
    signed_cookies[:session] = { value: { "token" => "TOKEN", "refresh_token" => "REFRESH_TOKEN", "expires_at" => 1.hour, "expires" => true } }
  end
end
