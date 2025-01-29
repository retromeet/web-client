# frozen_string_literal: true

module RetroMeet
  module Core
    # Sub-class for the BasicProfileInfo
    class Listing < Representation
      # This is the distance that nearby shows by default, the value should be in sync with retromeet-core
      DEFAULT_MAX_DISTANCE_IN_KM = 5

      # @return [Array<OtherProfileInfo>]
      def nearby
        value[:profiles].map! do |result|
          ::OtherProfileInfo.new(**result.slice(*::OtherProfileInfo.members))
        end
      end
    end
  end
end
