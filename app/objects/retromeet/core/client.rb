# frozen_string_literal: true

require "net/http/post/multipart"

# This client is designed to connect to retromeet core.
# It can be used statictly for actions unrelated to users, but then it needs to be instantiated for other operations.
module RetroMeet
  module Core
    # This client is designed to connect to retromeet core.
    # It can be used statictly for actions unrelated to users, but then it needs to be instantiated for other operations.
    class Client < Async::REST::Resource
      # The base endpoint for retromeet
      # @type [Async::HTTP::Endpoint]
      ENDPOINT = Async::HTTP::Endpoint.parse(Rails.configuration.x.retromeet_core_host)

      # @param authorization_header [String]
      # @return [RetroMeet::Client] An authorized client
      def authenticated(authorization_header)
        with(headers: { authorization: authorization_header })
      end

      # @return [RetroMeet::Client::BasicProfileInfo]
      def basic_profile_info
        BasicProfileInfo.new(with(path: "/api/profile/info"))
      end

      # @return [RetroMeet::Client::ProfileInfo]
      def profile_info
        ProfileInfo.new(with(path: "/api/profile/complete"))
      end

      # @param other_profile_id [Integer]
      # @return [RetroMeet::Client::OtherProfile]
      def other_profile(other_profile_id:)
        OtherProfile.new(with(path: "/api/profile/#{other_profile_id}"))
      end

      # @return [RetroMeet::Client::Listing]
      def listing
        Listing.new(with(path: "/api/listing"))
      end

      # @return [RetroMeet::Client::Conversation]
      def conversations
        Conversations.new(with(path: "/api/conversations"))
      end

      # @param conversation_id [String] a uuid for the conversation
      # @return [RetroMeet::Client::Conversation]
      def conversation(conversation_id:)
        Conversation.new(with(path: "/api/conversations/#{conversation_id}"))
      end

      # (see Login#login)
      def login(login:, password:)
        Login.new(with(path: "/login"))
             .login(login, password)
      end

      # (see Logout#logout)
      def logout
        Logout.new(with(path: "/logout"))
              .logout
      end

      # (see CreateAccount#create_account)
      def create_account(login:, password:, birth_date:)
        CreateAccount.new(with(path: "/create-account"))
                     .create_account(login:, password:, birth_date:)
      end

      # (see Image#image)
      def image(path:)
        Image.new(with(path: "/api#{path}"))
      end
    end

    #   # Calls the profile info endpoint in retromeet-core and returns the response as a ruby object
    #   #
    #   # @raise [UnauthorizedError] If it has a bad login
    #   # @raise [UnknownError] If an unknown error happens
    #   # @return [ProfileInfo]
    #   def location_search(query:)
    #     return nil if @authorization_header.blank?

    #     body = { query: }.to_json
    #     Sync do
    #       response = client.post("/api/search/address", headers: base_headers, body:)
    #       case response.status
    #       when 200
    #         response_body = JSON.parse(response.read, symbolize_names: true)
    #         response_body.map! do |result|
    #           LocationResult.new(**result.slice(*LocationResult.members))
    #         end
    #       else
    #         raise UnknownError, "An unknown error happened while calling retromeet-core"
    #       end
    #     ensure
    #       response&.close
    #     end
    #   end

    #   # Calls the update profile location endpoint in retromeet-core and returns the response as a ruby object
    #   # @param location [String] A location to be used as the current profile location
    #   # @param osm_id [Integer] The OSM id to be matched to the location
    #   # @return [TrueClass] If the request is sucessfull
    #   def update_profile_location(location:, osm_id:)
    #     return nil if @authorization_header.blank?

    #     body = { location:, osm_id: }.to_json
    #     Sync do
    #       response = client.post("/api/profile/location", headers: base_headers, body:)
    #       case response.status
    #       when 200
    #         true
    #       when 400
    #         pp response.read
    #         # TODO: Treat bad requests
    #         raise UnknownError
    #       when 401
    #         raise UnauthorizedError, "Not logged in"
    #       when 422
    #         error = JSON.parse(response.read, symbolize_names: true)
    #         raise UnprocessableRequestError, error[:detail]
    #       else
    #         raise UnknownError, "An unknown error happened while calling retromeet-core"
    #       end
    #     ensure
    #       response&.close
    #     end
    #   end

    #   # @param other_profile_id [String] a uuid of the other profile in the conversation
    #   # @return [String] The uuid of the created conversation (or of an existing one)
    #   def create_conversation(other_profile_id:)
    #     return nil if @authorization_header.blank?

    #     body = { other_profile_id: }.to_json
    #     Sync do
    #       response = client.post("/api/conversations", headers: base_headers, body:)
    #       case response.status
    #       when 201
    #         JSON.parse(response.read, symbolize_names: true)[:id]
    #       else
    #         raise UnknownError, "An unknown error happened while calling retromeet-core"
    #       end
    #     ensure
    #       response&.close
    #     end
    #   end

    #   # @param conversation_id [String] a uuid for the conversation you want to send a message to
    #   # @param content [String] The content of the message
    #   # @return [Hash] Will return the message if the insert was sucessfull
    #   def send_message(conversation_id:, content:)
    #     return nil if @authorization_header.blank?

    #     body = { content: }.to_json
    #     Sync do
    #       response = client.post("/api/conversations/#{conversation_id}/messages", headers: base_headers, body:)
    #       case response.status
    #       when 201
    #         JSON.parse(response.read, symbolize_names: true)
    #       else
    #         raise UnknownError, "An unknown error happened while calling retromeet-core"
    #       end
    #     ensure
    #       response&.close
    #     end
    #   end

    #   # Calls the profile info endpoint in retromeet-core and returns the response as a ruby object
    #   #
    #   # @param conversation_id (see #send_message)
    #   # @param min_id [Integer, nil] if it's not nil, will only return messages with ids bigger than this. Good to get new messages
    #   # @param max_id [Integer, nil] if it's not nil, will only return messages with ids smaller than this. Good to paginate results
    #   # @raise [UnauthorizedError] If it has a bad login
    #   # @raise [UnknownError] If an unknown error happens
    #   # @return [Array<OtherProfileInfo>]
    #   def find_messages(conversation_id:, min_id: nil, max_id: nil)
    #     return nil if @authorization_header.blank?

    #     params = {}
    #     params[:min_id] = min_id if min_id
    #     params[:max_id] = max_id if max_id

    #     query_params = params.map { |k, v| "#{k}=#{v}" }.join("&")

    #     Sync do
    #       response = client.get("/api/conversations/#{conversation_id}/messages?#{query_params}", headers: base_headers)
    #       case response.status
    #       when 200
    #         response_body = JSON.parse(response.read, symbolize_names: true)
    #         response_body[:messages].map! do |result|
    #           Message.new(**result.slice(*Message.members))
    #         end
    #       else
    #         raise UnknownError, "An unknown error happened while calling retromeet-core"
    #       end
    #     ensure
    #       response&.close
    #     end
    #   end

    #   # @param filename [String] The name of the file
    #   # @param io [File] The file to be uploaded
    #   # @param content_type [String] The content type of the original file
    #   # @return [void]
    #   def upload_profile_picture(filename:, io:, content_type:)
    #     return nil if @authorization_header.blank?

    #     form_data = {
    #       profile_picture: ::Multipart::Post::UploadIO.new(io, content_type, filename)
    #     }
    #     headers = {}
    #     multipart_post = ::Net::HTTP::Post::Multipart.new("/api/profile/picture", form_data, headers)
    #     headers["Content-Type"] = multipart_post["content-type"]
    #     Sync do
    #       response = client.post("/api/profile/picture", headers: base_headers.merge(headers), body: multipart_post.body_stream.read)
    #       case response.status
    #       when 204
    #         true
    #       end
    #     ensure
    #       response&.close
    #     end
    #   end

    #   # @param other_profile_id (see #create_conversation)
    #   # @return [Boolean]
    #   def block_profile(other_profile_id:)
    #     return nil if @authorization_header.blank?

    #     Sync do
    #       response = client.post("/api/profile/#{other_profile_id}/block", headers: base_headers)
    #       case response.status
    #       when 204
    #         true
    #       else
    #         raise UnknownError, "An unknown error happened while calling retromeet-core"
    #       end
    #     ensure
    #       response&.close
    #     end
    #   end

    #   # @param other_profile_id (see #create_conversation)
    #   # @return [Boolean]
    #   def unblock_profile(other_profile_id:)
    #     return nil if @authorization_header.blank?

    #     Sync do
    #       response = client.delete("/api/profile/#{other_profile_id}/block", headers: base_headers)
    #       case response.status
    #       when 204
    #         true
    #       else
    #         raise UnknownError, "An unknown error happened while calling retromeet-core"
    #       end
    #     ensure
    #       response&.close
    #     end
    #   end
  end
end
