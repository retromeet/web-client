# frozen_string_literal: true

module RetroMeet
  # This module contains the Client and other objects related to the connection to the Core.
  # The entry point should be via the +connect+ method, which will give a proper Client to work with.
  module Core
    Error = Class.new(StandardError)

    UnauthorizedError = Class.new(Error)
    BadPasswordError = Class.new(UnauthorizedError)
    BadLoginError = Class.new(UnauthorizedError)

    UnprocessableRequestError = Class.new(Error)

    UnknownError = Class.new(Error)

    LoginAlreadyTakenError = Class.new(Error)

    TooYoungError = Class.new(Error)

    class << self
      BASE_HEADERS = { "Content-Type" => "application/json", "User-Agent": RetroMeet::Version.user_agent }.freeze

      # @param user_ip [String] The ip of the user that started the request. Will be forwarded to core
      # @param authorization_header [String,nil] If present, will return an authenticated client
      # @yieldreturn [Client]
      def connect(user_ip, authorization_header: nil)
        client = Client.open
                       .with(headers: BASE_HEADERS.merge("X-Forwarded-For": user_ip))

        client = client.authenticated(authorization_header) if authorization_header

        Sync do
          yield client
        ensure
          client.close
        end
      end
    end
  end
end
