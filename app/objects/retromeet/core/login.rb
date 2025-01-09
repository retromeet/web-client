# frozen_string_literal: true

module RetroMeet
  module Core
    # Sub-class for the login
    class Login < SessionRepresentation
      # @param login [String] The login to use in retromeet-core, should be an email
      # @param password [String] The user password
      # @raise [BadLoginError]
      # @raise [BadPasswordError]
      # @raise [UnauthorizedError]
      # @raise [UnknownError]
      # @return [String] The authorization header to be used for requests
      def login(login, password)
        body = { login:, password: }
        res = Login.post(@resource, body)
        res.metadata["authorization"]
      rescue JsonResponseError => e
        field_error = begin
          e.body.dig(:"field-error", 0)
        rescue
          "unknown field"
        end

        # (renatolond, 2024-09-15) in rodauth the wrong password and username are two different errors.
        # jeremyevans says an attacker can detect with a timing attack (from https://github.com/jeremyevans/rodauth/pull/45#issuecomment-338418163)
        # Look into it more and decide if we keep generic errors or not
        case field_error
        when "login"
          raise BadLoginError, "Unauthorized, login is unknown"
        when "password"
          raise BadPasswordError, "Unauthorized, password is incorrect"
        else
          raise UnauthorizedError, "Unauthorized, unknown error"
        end
      end
    end
  end
end
