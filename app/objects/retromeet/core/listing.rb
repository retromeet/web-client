# frozen_string_literal: true

module RetroMeet
  module Core
    # Sub-class for the BasicProfileInfo
    class Listing < Representation
      # @return [Array<OtherProfileInfo>]
      def nearby
        value[:profiles].map! do |result|
          ::OtherProfileInfo.new(**result.slice(*::OtherProfileInfo.members))
        end
      end
    end
  end
end
