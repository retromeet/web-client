# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  before_action :basic_profile_info

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protected

    # Gets base information about a profile, things that are needed to show the profile info a of a logged-in user
    # @return [BasicProfileInfo] if the user is logged in
    # @return [nil] if the user is not logged in
    def basic_profile_info
      @basic_profile_info ||= retro_meet_client.basic_profile_info if authenticated?
    rescue RetroMeet::Client::UnauthorizedError
      flash.now[:warn] = t("forced_log_out")
      terminate_session
      redirect_to :root
    end

    def retro_meet_client = @retro_meet_client ||= RetroMeet::Client.new(Current.session, request.ip)
end
