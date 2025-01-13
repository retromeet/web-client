# frozen_string_literal: true

module RetroMeet
  module Core
    # Sub-class for the BasicProfileInfo
    class BasicProfileInfo < Representation
      # @return [::BasicProfileInfo] The basic profile info
      def value
        ::BasicProfileInfo.new(**super.slice(*::BasicProfileInfo.members))
      end
    end
  end
end
