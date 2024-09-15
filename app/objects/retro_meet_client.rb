# frozen_string_literal: true

# This client is designed to connect to retromeet core.
# It can be used statictly for actions unrelated to users, but then it needs to be instantiated for other operations.
module RetroMeetClient
  RetroMeetError = Class.new(StandardError)
  UnauthorizedError = Class.new(RetroMeetError)

  class << self
    def login(username:, password:)
      Sync do
        response = client.get("/login", headers: base_headers)
        case response.status
        when 200
          response_headers = response.headers
          response_headers["authorization"]
        when 401
          begin
            field_error = JSON.parse(response.read, symbolize_names: true)[:"field-error"].first
          rescue
            field_error = "unknown field"
          end
          raise UnauthorizedError, "Unauthorized, #{field_error} is incorrect"
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
