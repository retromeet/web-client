# frozen_string_literal: true

# This client is designed to connect to retromeet core.
# It can be used statictly for actions unrelated to users, but then it needs to be instantiated for other operations.
class RetroMeetClient
  RetroMeetError = Class.new(StandardError)
  UnauthorizedError = Class.new(RetroMeetError)
  BadPasswordError = Class.new(UnauthorizedError)
  BadLoginError = Class.new(UnauthorizedError)
  UnknownError = Class.new(RetroMeetError)
  LoginAlreadyTakenError = Class.new(RetroMeetError)

  def initialize(authorization_header)
    @authorization_header = authorization_header
  end

  # (renatolond, 2024-09-17) Look into a better way to call those instance methods without a .send

  # @return (see .client)
  def client = self.class.send(:client)

  # @return (see .base_headers)
  def base_headers
    @base_headers ||= self.class.send(:base_headers).merge(authorization: @authorization_header)
  end

  # Calls the basic profile info endpoint in retromeet-core and returns the response as a ruby object
  #
  # @raise [UnauthorizedError] If it has a bad login
  # @raise [UnknownError] If an unknown error happens
  # @return [BasicProfileInfo]
  def basic_profile_info
    return nil if @authorization_header.blank?

    Sync do
      response = client.get("/api/profile/info", headers: base_headers)
      case response.status
      when 200
        response_body = JSON.parse(response.read, symbolize_names: true)
        BasicProfileInfo.new(response_body[:display_name], response_body[:created_at])
      when 401
        raise UnauthorizedError, "Not logged in"
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    ensure
      response&.close
    end
  end

  # Calls the profile info endpoint in retromeet-core and returns the response as a ruby object
  #
  # @raise [UnauthorizedError] If it has a bad login
  # @raise [UnknownError] If an unknown error happens
  # @return [ProfileInfo]
  def profile_info
    return nil if @authorization_header.blank?

    Sync do
      response = client.get("/api/profile/complete", headers: base_headers)
      case response.status
      when 200
        # @type [Hash{Symbol=>Object}]
        response_body = JSON.parse(response.read, symbolize_names: true)
        ProfileInfo.new(**response_body.slice(*ProfileInfo.members))
      when 401
        raise UnauthorizedError, "Not logged in"
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    ensure
      response&.close
    end
  end

  # Logs out from retromeet-core
  # @raise [UnknownError] If an unknown error happens
  # @return [void]
  def sign_out
    return nil if @authorization_header.blank?

    Sync do
      response = client.post("/logout", headers: base_headers)
      case response.status
      when 200
        @authorization_header = nil
      else
        raise UnknownError, "An unknown error happened while calling retromeet-core"
      end
    end
  end

  class << self
    # Tries to create an account in retromeet-core and converts any http errors into Ruby exceptions
    # @param login (see .login)
    # @param password (see .login)
    # @raise [UnknownError] If an unknown error happens
    # @return (see .login)
    def create_account(login:, password:)
      Sync do
        body = { login:, password: }.to_json
        response = client.post("/create-account", headers: base_headers, body:)
        case response.status
        when 200
          response_headers = response.headers
          response_headers["authorization"]
        when 422
          begin
            response_body = JSON.parse(response.read, symbolize_names: true)
            field_error = response_body.dig(:"field-error", 0)
            field_message = response_body.dig(:"field-error", 1)
          rescue
            field_error = "unknown field"
          end

          raise LoginAlreadyTakenError, "This login already exists" if field_error == "login" && field_message["already an account with this login"]
          raise BadLoginError, "Invalid login" if field_error == "login"
          raise BadPasswordError, "Invalid password" if field_error == "password"

          raise UnknownError
        else
          raise UnknownError, "Something went wrong, code=#{response.status}"
        end
      ensure
        response&.close
      end
    end

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

    protected

      # Returns the retromeet-core base host to be used for requests based off the environment variables
      # @return [Async::HTTP::Endpoint]
      def retromeet_core_host = @retromeet_core_host ||= Async::HTTP::Endpoint.parse("http://localhost:3000")

      # @return [Hash] Base headers to be used for requests
      def base_headers = @base_headers ||= { "Content-Type" => "application/json" }.freeze

      # @return [Async::HTTP::Client]
      def client = Async::HTTP::Client.new(retromeet_core_host)
  end
end
