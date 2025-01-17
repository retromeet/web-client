# frozen_string_literal: true

module RetroMeet
  module Core
    # Extends the base async representation class
    class Representation < Async::REST::Representation[Wrapper]
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

        # @param resource [Async::REST::Resource]
        # @param payload [nil,Object]
        # @raise [Async::REST::ResponseError]
        # @return [Async::REST::Resource]
        def put(resource, payload = nil, &)
          super do |original_resource, response, original_self|
            raise UnauthorizedError, "Not logged in" if response.status == 401
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
        rescue JsonResponseError => e
          raise UnauthorizedError, "Not logged in" if e.response.status == 401

          raise
        end

        # @return (see Async::REST::Representation#post)
        # @raise (see Async::REST::Representation#post)
        # @raise [UnauthorizedError]
        def post
          self.class::WRAPPER.call(@resource, "POST") do |response|
            raise JsonResponseError, response unless response.success?

            @metadata = response.headers
            @value = response.read
          end
        rescue JsonResponseError => e
          raise UnauthorizedError, "Not logged in" if e.response.status == 401

          raise
        end
    end
  end
end
