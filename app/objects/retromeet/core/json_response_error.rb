# frozen_string_literal: true

module RetroMeet
  module Core
    # Represents errors coming from JSON responses
    class JsonResponseError < StandardError
      def initialize(response)
        @body = response.read
        super(@body)
        @response = response
      end

      # @return [String]
      def to_s
        "#{@response}: #{super}"
      end

      attr_reader :body, :response
    end
  end
end
