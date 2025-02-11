# frozen_string_literal: true

module Routes
  # A helper to be used in the routes file to check for logged-in status
  module AuthenticationHelper
    # Can be used in the routes to check if there's a logged in user
    # Is not a replacement for checking it in the controllers, it is a helper only to change the root depending on logged-in state.
    def logged_in(&)
      authenticated?(&)
    end

    private

      # Adds a constraint to check if the user is logged-in
      def authenticated?(&)
        constraint = lambda do |request|
          request.cookie_jar.signed[:session].present?
        end

        constraints(constraint, &)
      end
  end
end
