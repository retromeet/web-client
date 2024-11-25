# frozen_string_literal: true

class ListingController < ApplicationController
  def show
    @profiles = retro_meet_client.nearby
  end
end
