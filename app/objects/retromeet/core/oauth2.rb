# frozen_string_literal: true

module RetroMeet
  module Core
    # OAuth endpoints representation
    class OAuth2 < Representation
      # @param callback_path [String] The relative path for the login callback
      # @return [Hash{Symbol => Object}] A hash containing +client_id+, +client_secret+ and +registration_access_token+
      def register(callback_path)
        params = {
          client_name: "RetroMeet Web",
          description: "RetroMeet Web is the companion client to RetroMeet",
          scopes: "profile",
          token_endpoint_auth_method: "client_secret_post",
          grant_types: %w[authorization_code refresh_token],
          response_types: %w[code],
          redirect_uris: ["#{RetroMeet::Url.to_s.chomp("/")}#{callback_path}"],
          client_uri: RetroMeet::Url.to_s,
          logo_uri: "#{RetroMeet::Url}logo.png",
          policy_uri: "#{RetroMeet::Url}privacy"
        }.freeze
        response = OAuth2.post(@resource.with(path: "#{@resource.path}/register"), params)
        response.value.slice(:client_id, :registration_access_token, :client_secret)
      end
    end
  end
end
