# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  around_action :create_client
  before_action :basic_profile_info

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protected

    def create_client
      RetroMeet::Core.connect(request.ip, authorization_header: Current.session&.headers&.[]("Authorization")) do |client|
        @retro_meet_client = client
        yield
        @retro_meet_client = nil
      end
    end

    # Gets base information about a profile, things that are needed to show the profile info a of a logged-in user
    # @return [BasicProfileInfo] if the user is logged in
    # @return [nil] if the user is not logged in
    def basic_profile_info
      @basic_profile_info ||= retro_meet_client.basic_profile_info.value if authenticated?
    rescue RetroMeet::Core::UnauthorizedError
      flash.now[:warn] = t("forced_log_out")
      # terminate_session
      # redirect_to :root
    end

    # @return [nil,RetroMeet::Core::Client]
    attr_reader :retro_meet_client
end
