# frozen_string_literal: true

class ProfilesController < ApplicationController
  def show
    @profile_info = retro_meet_client.profile_info
  end

  def edit
    @profile_info = retro_meet_client.profile_info
  end

  def update
    @profile_info = ProfileInfo.new(**profile_params.to_hash.transform_keys!(&:to_sym))
    render :edit, status: :unprocessable_content
  end

  def view
    @profile_info = ProfileInfo.new
    render "show"
  end

  private

    def profile_params
      params.require(:profile).permit(:about_me)
    end
end
