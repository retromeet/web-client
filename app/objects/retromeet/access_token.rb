# frozen_string_literal: true

module RetroMeet
  class AccessToken < ::OAuth2::AccessToken
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
