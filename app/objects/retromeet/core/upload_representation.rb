# frozen_string_literal: true

module RetroMeet
  module Core
    # Extends the base async representation class to upload a file
    class UploadRepresentation < Async::REST::Representation[Async::REST::Wrapper::Generic]
      class << self
        # @param resource [Async::REST::Resource]
        # @param payload [nil,Object]
        # @raise [Async::REST::ResponseError]
        # @return [Async::REST::Resource]
        def post(resource, payload = nil, &)
          super do |original_resource, response, original_self|
            raise UnauthorizedError, "Not logged in" if response.status == 401
            raise JsonResponseError, response unless response.success?

            original_self.new(original_resource, value: response.read, metadata: response.headers)
          end
        end
      end
    end
  end
end
