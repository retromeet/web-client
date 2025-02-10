# frozen_string_literal: true

module RetroMeet
  # This class adds a revoke action for the AccessToken allowing logouts
  class AccessToken < ::OAuth2::AccessToken
    # Revokes the access token by calling RetroMeet core
    # @return [void]
    def revoke!
      authenticator = ::OAuth2::Authenticator.new(client.id, client.secret, client.options[:auth_scheme])
      params = { token: token, token_type_hint: "access_token" }
      params = authenticator.apply(params)
      request_opts = {
        body: params.to_json,
        headers: { "Content-Type" => "application/json", "Accept" => "application/json" }
      }
      post("/revoke", request_opts)
    end
  end
end
