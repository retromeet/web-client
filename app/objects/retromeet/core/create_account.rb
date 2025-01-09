# frozen_string_literal: true

module RetroMeet
  module Core
    # Sub-class for the login
    class CreateAccount < SessionRepresentation
      # @param login [String] The login to use in retromeet-core, should be an email
      # @param password [String] The user password
      # @param birth_date [Date,String] The birth date of the user
      # @raise [BadLoginError]
      # @raise [BadPasswordError]
      # @raise [UnauthorizedError]
      # @raise [UnknownError]
      # @return [String] The authorization header to be used for requests
      def create_account(login:, password:, birth_date:)
        body = { login:, password:, birth_date: }
        res = Login.post(@resource, body)
        res.metadata["authorization"]
      rescue JsonResponseError => e
        raise UnknownError, "An uknown error happened while calling retromeet-core" unless e.response.status == 422

        field_error = begin
          e.body.dig(:"field-error", 0)
        rescue
          "unknown field"
        end
        field_message = e.body.dig(:"field-error", 1)

        raise LoginAlreadyTakenError, "This login already exists" if field_error == "login" && field_message["already an account with this login"]
        raise BadLoginError, "Invalid login" if field_error == "login"
        raise BadPasswordError, "Invalid password" if field_error == "password"
        raise TooYoungError, "Must be 18 years or older" if field_error == "birth_date" && field_message["must be 18"]
        raise Date::Error, "Invalid date" if field_error == "birth_date"

        raise UnknownError, "An uknown error happened while calling retromeet-core"
      end
    end
  end
end
