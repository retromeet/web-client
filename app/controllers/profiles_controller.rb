# frozen_string_literal: true

class ProfilesController < ApplicationController
  def show
    @profile_info = ProfileInfo.new
  end
end
