# frozen_string_literal: true

require "net/http/post/multipart"

module RetroMeet
  module Core
    # Representation class for the profile picture
    class ProfilePicture < UploadRepresentation
      # @param filename [String] The name of the file
      # @param io [File] The file to be uploaded
      # @param content_type [String] The content type of the original file
      # @return [void]
      def upload(filename:, io:, content_type:)
        form_data = {
          profile_picture: ::Multipart::Post::UploadIO.new(io, content_type, filename)
        }
        headers = {}
        multipart_post = ::Net::HTTP::Post::Multipart.new("/api/profile/picture", form_data, headers)
        ProfilePicture.post(@resource.with(headers: { "Content-Type": multipart_post["content-type"] }), multipart_post.body_stream.read)
      end
    end
  end
end
