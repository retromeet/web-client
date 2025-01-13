# frozen_string_literal: true

module RetroMeet
  module Core
    # Contains method related to a user's own profile info
    class ProfileInfo < Representation
      # @return [ProfileInfo] Description
      def value
        ::ProfileInfo.new(**super.slice(*::ProfileInfo.members))
      end

      # @param params [Hash] A hash containing the params to be passed on to core. Will be modified!
      def update(params)
        params.transform_values!(&:presence)
        params[:languages]&.delete("")
        params[:genders]&.delete("")
        params[:orientations]&.delete("")

        ProfileInfo.post(@resource, params)
      end
    end
  end
end
