# frozen_string_literal: true

module RetroMeet
  module Core
    # When the core is not using some kind of object storage, then
    # this class can proxy images from the core to the web.
    # The recommendation however is that the core uses some kind of object storage
    # even if a self hosted one like minio
    class Image < Async::REST::Representation[Async::REST::Wrapper::Generic]
      # This method is only used if the core is storing pictures locally
      # It basically proxies the images from the core to the application
      #
      # @param path [String] The path to the image
      # @return [List<Integer,Hash,String>] Status, headers and body
      def image
        Image.get(@resource) do |_resource, response, _o_self|
          [response.status, response.headers, response.read]
        end
      end
    end
  end
end
