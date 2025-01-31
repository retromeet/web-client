# frozen_string_literal: true

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
      def listing(max_distance: Listing::DEFAULT_MAX_DISTANCE_IN_KM)
        Listing.new(with(path: "/api/listing", parameters: { max_distance: }))
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

      # @return [AddressSearch]
      def address_search(query:)
        AddressSearch.new(with(path: "/api/search/address", parameters: { query: }))
      end

      # @return [ProfilePicture]
      def profile_picture
        ProfilePicture.new(with(path: "/api/profile/picture"))
      end

      # @return [Reports]
      def reports
        Reports.new(with(path: "/api/reports"))
      end
    end
  end
end
