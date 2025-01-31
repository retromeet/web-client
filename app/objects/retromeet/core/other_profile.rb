# frozen_string_literal: true

module RetroMeet
  module Core
    # Sub-class for other profiles interaction
    class OtherProfile < Representation
      # @return [OtherProfileInfo]
      def profile_info
        OtherProfileInfo.new(@resource.with(path: "#{resource.path}/complete"))
      end

      # @return (see Conversation#value)
      def conversation
        Conversation.new(@resource.with(path: "#{resource.path}/conversation")).value
      rescue RetroMeet::Core::JsonResponseError => e
        return nil if e.response.status == 404

        raise
      end

      # @return [Boolean]
      def block!
        OtherProfile.post(@resource.with(path: "#{resource.path}/block"))
        true
      end

      # @return [Boolean]
      def unblock!
        OtherProfile.delete(@resource.with(path: "#{resource.path}/block"))
        true
      end
    end
  end
end
