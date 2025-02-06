# frozen_string_literal: true

module OmniAuth
  module Strategies
    # Class that defines the strategy for the RetroMeet core oauth
    class RetroMeetCore < OmniAuth::Strategies::OAuth2
      # TODO: come from env vars, pre-registered
      CLIENT_ID = ""
      CLIENT_SECRET = ""
      # This constant needs to use only symbols or the .client call might fail. Beware!
      CLIENT_OPTIONS = { site: Rails.configuration.x.retromeet_core_host, authorize_url: "/authorize", token_url: "/token", auth_scheme: :request_body }.freeze

      option :name, "retromeet_core"
      option :client_id, CLIENT_ID
      option :client_secret, CLIENT_SECRET
      option :client_options, CLIENT_OPTIONS
      option :authorize_params, { response_mode: :query }

      option :callback_path, "/auth/callback"

      # Overrides the OmniAuth::Strategies::OAuth2 function adding some headers needed for RetroMeet's omniauth
      # @return [::OAuth2::AccessToken]
      def build_access_token
        verifier = request.params["code"]
        client.auth_code.get_token(verifier, { redirect_uri: callback_url_without_query, headers: { "Content-Type" => "application/json", "Accept" => "application/json" } }.merge(token_params.to_hash(symbolize_keys: true)), deep_symbolize(options.auth_token_params))
      end

      # @return [String]
      def callback_url_without_query
        full_host + callback_path
      end

      class << self
        # @return [::Oauth2::Client] A client that uses the same options as this strategy
        def client
          ::OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, CLIENT_OPTIONS)
        end
      end
    end
  end
end
