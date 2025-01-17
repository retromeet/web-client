# frozen_string_literal: true

module RetroMeet
  module Core
    # Address Search representation
    class AddressSearch < Representation
      # @return [Array<::LocationResult>]
      def value
        @value ||= post.map! do |result|
          ::LocationResult.new(**result.slice(*::LocationResult.members))
        end
      end
    end
  end
end
