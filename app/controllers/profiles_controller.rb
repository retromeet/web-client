# frozen_string_literal: true

class ProfilesController < ApplicationController
  def show
    @profile_info = retro_meet_client.profile_info
  end

  def edit
    @profile_info = retro_meet_client.profile_info
  end

  def view
    @profile_info = ProfileInfo.new
    render "show"
  end
end
