# frozen_string_literal: true

module RetroMeet
  module Core
    # Sub-class for the Conversations endpoints
    class Conversations < Representation
      # @return [Array<::Conversation>] A list of conversations
      def value
        super[:conversations].map! do |conversation|
          ::Conversation.new(**conversation.slice(*::Conversation.members))
        end
      end

      # @param other_profile_id [String] a uuid of the other profile in the conversation
      # @return [String] The uuid of the created conversation (or of an existing one)
      def create(other_profile_id:)
        body = { other_profile_id: }
        Conversation.post(@resource, body)
                    .value
                    .id
      end
    end
  end
end
