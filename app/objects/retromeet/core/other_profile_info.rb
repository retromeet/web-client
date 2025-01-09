# frozen_string_literal: true

module RetroMeet
  module Core
    # Sub-class for other profiles interaction
    class OtherProfileInfo < Representation
      # @return [OtherProfileInfo]
      def value
        ::OtherProfileInfo.new(**super.slice(*::OtherProfileInfo.members))
      end
    end
  end
end
