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
    def allow_unauthenticated_access(**)
      skip_before_action :require_authentication, **
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
      Current.session ||= if find_session_by_cookie
        at = OAuth2::AccessToken.from_hash(OmniAuth::Strategies::RetroMeetCore.client, find_session_by_cookie&.except!("expires"))
        at = at.refresh({ headers: { "Content-Type" => "application/json", "Accept" => "application/json" } }) if at.expired?
        cookies.signed[:session] = { value: at.to_hash, httponly: true, same_site: :strict }
        at
      end
    end

    # @return [Hash]
    def find_session_by_cookie
      cookies.signed[:session]
    end

    # Sets the return url and redirects to login page
    # @return [void]
    def request_authentication
      session[:return_to_after_authenticating] = request.url
      flash.now[:error] = I18n.t("you_need_to_be_logged_in")
      redirect_to root_url
    end

    # Will either return the url the user was at before, or the root
    #
    # @return [String] The url to go after the login
    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    # Sets the cookie for the new session
    # @return [void]
    def start_new_session_for(token_credentials)
      # TODO: check expiration time
      cookies.signed[:session] = { value: token_credentials, httponly: true, same_site: :strict }
    end

    # Logs out from retro meet core and removes the session cookie
    # @return [void]
    def terminate_session
      # retro_meet_client.logout
      # cookies.delete(:session)
    end
end
