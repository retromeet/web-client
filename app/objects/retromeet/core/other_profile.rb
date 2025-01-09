# frozen_string_literal: true

module RetroMeet
  module Core
    # Sub-class for other profiles interaction
    class OtherProfile < Representation
      # @return [OtherProfileInfo]
      def profile_info
        OtherProfileInfo.new(@resource.with(path: "#{resource.path}/complete"))
      end
    end
  end
end
