# frozen_string_literal: true

module RetroMeet
  module Core
    # Sub-class for the Messages endpoint
    class Messages < Representation
      # @return [Array<::Message>] A list of conversations
      def value
        v = super[:messages].map! do |conversation|
          ::Message.new(**conversation.slice(*::Message.members))
        end
        v.reverse!
        v
      end
    end
  end
end
