# frozen_string_literal: true

class Profiles::LocationsController < ApplicationController
  def search
    @locations = retro_meet_client.address_search(query: params["location_name"])
                                  .value
  end

  def update
    location, osm_id = params["location"].split("|", 2)
    retro_meet_client.profile_info
                     .update_location(location:, osm_id:)
    if response
      redirect_to profile_path, status: :see_other
    else
      @location = params[:location]
      render :edit, status: :unprocessable_content
    end
  rescue RetroMeet::Core::UnprocessableRequestError => e
    @location = params[:location]
    flash[:error] = e.message
    render :edit, status: :unprocessable_content
  end
end
