# frozen_string_literal: true

module Profiles
  class BlocksController < ApplicationController
    def create
      retro_meet_client.block_profile(other_profile_id: params[:other_profile])
      redirect_to listing_path, status: :see_other
    end

    def delete; end
  end
end
