# frozen_string_literal: true

# This client is designed to connect to retromeet core.
# It can be used statictly for actions unrelated to users, but then it needs to be instantiated for other operations.
module RetroMeetClient
  RetroMeetError = Class.new(StandardError)
  UnauthorizedError = Class.new(RetroMeetError)
  BadPasswordError = Class.new(UnauthorizedError)
  BadLoginError = Class.new(UnauthorizedError)
  UnknownError = Class.new(RetroMeetError)

  class << self
    # Tries to login to retromeet-core and converts any http errors into Ruby exceptions
    # @param login [String] The login to use in retromeet-core, should be an email
    # @param password [String]
    # @raise [UnauthorizedError] If one of the login fields is incorrect
    # @raise [UnknownError] If an unknown error happens
    # @return [String] If the request was sucessfull, will return the jwt authoriztion token to be used for requests
    def login(login:, password:)
      Sync do
        body = { login:, password: }.to_json
        response = client.post("/login", headers: base_headers, body:)
        case response.status
        when 200
          response_headers = response.headers
          response_headers["authorization"]
        when 401
          begin
            field_error = JSON.parse(response.read, symbolize_names: true).dig(:"field-error", 0)
          rescue
            field_error = "unknown field"
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
        else
          raise UnknownError, "Something went wrong, code=#{response.status}"
        end
      ensure
        response&.close
      end
    end

    private

      # Returns the retromeet-core base host to be used for requests based off the environment variables
      # @return [Async::HTTP::Endpoint]
      def retromeet_core_host = @retromeet_core_host ||= Async::HTTP::Endpoint.parse("http://localhost:3000")

      # @return [Hash] Base headers to be used for requests
      def base_headers = @base_headers ||= { "Content-Type" => "application/json" }.freeze

      # @return [Async::HTTP::Client]
      def client = Async::HTTP::Client.new(retromeet_core_host)
  end
end
