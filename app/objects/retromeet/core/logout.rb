# frozen_string_literal: true

module RetroMeet
  module Core
    # Sub-class for the login
    class Logout < SessionRepresentation
      # @raise [UnknownError]
      # @return [void]
      def logout
        Login.post(@resource)
      rescue JsonResponseError
        raise UnknownError, "An uknown error happened while calling retromeet-core"
      end
    end
  end
end
