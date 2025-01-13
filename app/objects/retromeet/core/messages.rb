# frozen_string_literal: true

module RetroMeet
  module Core
    # Sub-class for the Messages endpoint
    class Messages < Representation
      # @return [Array<::Message>] A list of conversations
      def value
        super[:messages].map! do |conversation|
          ::Message.new(**conversation.slice(*::Message.members))
        end
      end
    end
  end
end
