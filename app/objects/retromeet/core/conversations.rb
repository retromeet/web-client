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
    end
  end
end
