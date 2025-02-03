# frozen_string_literal: true

module OmniAuth
  module Strategies
    # Class that defines the strategy for the RetroMeet core oauth
    class RetroMeetCore < OmniAuth::Strategies::OAuth2
      # TODO: come from env vars, pre-registered
      CLIENT_ID = ""
      CLIENT_SECRET = ""

      option :name, "retromeet_core"
      option :client_id, CLIENT_ID
      option :client_secret, CLIENT_SECRET
      option :client_options, { site: Rails.configuration.x.retromeet_core_host, authorize_url: "/authorize", token_url: "/token", auth_scheme: :request_body }
      option :authorize_params, { response_mode: :query }

      option :callback_path, "/auth/callback"

      def build_access_token
        verifier = request.params["code"]
        client.auth_code.get_token(verifier, { redirect_uri: callback_url_without_query, headers: { "Content-Type" => "application/json", "Accept" => "application/json" } }.merge(token_params.to_hash(symbolize_keys: true)), deep_symbolize(options.auth_token_params))
      end

      def callback_url_without_query
        full_host + callback_path
      end
    end
  end
end
