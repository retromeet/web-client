# frozen_string_literal: true

class Profiles::LocationsController < ApplicationController
  def search
    @locations = retro_meet_client.location_search(query: params["location"])
  end
end
