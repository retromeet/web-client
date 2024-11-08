# frozen_string_literal: true

class Profiles::LocationsController < ApplicationController
  def search
    @locations = retro_meet_client.location_search(query: params["location_name"])
  end

  def update
    retro_meet_client.update_profile_location(location: params["location"])
    if response
      redirect_to profile_path, status: :see_other
    else
      @location = params[:location]
      render :edit, status: :unprocessable_content
    end
  rescue RetroMeetClient::UnprocessableRequestError => e
    @location = params[:location]
    flash[:error] = e.message
    render :edit, status: :unprocessable_content
  end
end
