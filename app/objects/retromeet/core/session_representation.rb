# frozen_string_literal: true

module RetroMeet
  module Core
    # Extends the base async representation class
    class SessionRepresentation < Async::REST::Representation[Wrapper]
      class << self
        # @param resource [Async::REST::Resource]
        # @param payload [nil,Object]
        # @raise [Async::REST::ResponseError]
        # @return [Async::Rest::Resource]
        def post(resource, payload = nil, &)
          super do |original_resource, response, original_self|
            raise JsonResponseError, response unless response.success?

            original_self.new(original_resource, value: response.read, metadata: response.headers)
          end
        end
      end

      private

        # @return (see Async::REST::Representation#get)
        # @raise (see Async::REST::Representation#get)
        # @raise [UnauthorizedError]
        def get
          self.class::WRAPPER.call(@resource) do |response|
            raise JsonResponseError, response unless response.success?

            @metadata = response.headers
            @value = response.read
          end
        end
    end
  end
end
