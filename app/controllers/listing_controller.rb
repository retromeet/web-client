# frozen_string_literal: true

class ListingController < ApplicationController
  def index
    @profiles = retro_meet_client.nearby
  end
end
