# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :basic_profile_info

  protected

    # @return [String,nil] The value of the authorization cookie
    def authorization_header
      cookies["Authorization"]
    end

    # Gets base information about a profile, things that are needed to show the profile info a of a logged-in user
    # @return [BasicProfileInfo] if the user is logged in
    # @return [nil] if the user is not logged in
    def basic_profile_info
      @basic_profile_info ||= retro_meet_client.basic_profile_info
    end

    def retro_meet_client = @retro_meet_client ||= RetroMeetClient.new(authorization_header)
end
