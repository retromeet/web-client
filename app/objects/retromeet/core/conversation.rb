# frozen_string_literal: true

module RetroMeet
  module Core
    # Sub-class for a single Conversation
    class Conversation < Representation
      # @return [Array<::Conversation>] A list of conversations
      def value
        ::Conversation.new(**super.slice(*::Conversation.members))
      end

      # @param min_id [Integer, nil] if it's not nil, will only return messages with ids bigger than this. Good to get new messages
      # @param max_id [Integer, nil] if it's not nil, will only return messages with ids smaller than this. Good to paginate results
      # @return [Messages]
      def messages(min_id: nil, max_id: nil)
        parameters = {}
        parameters[:min_id] = min_id if min_id
        parameters[:max_id] = max_id if max_id
        Messages.new(@resource.with(path: "#{resource.path}/messages", parameters:))
      end

      # @param content [String] The content of the sent message
      # @return [void]
      def send_message(content:)
        body = { content: }
        Messages.post(@resource.with(path: "#{resource.path}/messages"), body)
      end

      # Mark the conversation as viewed by the currently logged-in user
      # @return [void]
      def viewed!
        Conversation.put(@resource.with(path: "#{resource.path}/viewed"))
      end
    end
  end
end
