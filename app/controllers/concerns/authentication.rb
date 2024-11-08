# frozen_string_literal: true

# This module can be included in controllers to enable authentication and related methods.
# It will automatically require authentication for all methods on that controller and any children controllers
module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    # Method that allows some method in a controller to be unauthenticated. Should really only be used for root and sign_in/register actions
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

    # Check if there's a current session
    def authenticated?
      resume_session
    end

    # Makes sure that if there's no session, it will require auth
    def require_authentication
      resume_session || request_authentication
    end

    # Sets the current session from the cookie
    def resume_session
      Current.session ||= find_session_by_cookie
    end

    # (renatolond, 2024-11-08) should it be returning something more than the authorization cookie?
    #
    # @return [String]
    def find_session_by_cookie
      cookies.signed[:authorization]
    end

    # Sets the return url and redirects to login page
    # @return [void]
    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to new_session_path
    end

    # Will either return the url the user was at before, or the root
    #
    # @return [String] The url to go after the login
    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    # Sets the cookie for the new session
    # @return [void]
    def start_new_session_for(authorization_token)
      # TODO: check expiration time
      cookies.signed[:authorization] = { value: authorization_token, httponly: true, same_site: :strict }
    end

    # Logs out from retro meet core and removes the session cookie
    # @return [void]
    def terminate_session
      retro_meet_client.sign_out
      cookies.delete(:authorization)
    end
end
