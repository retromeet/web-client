# frozen_string_literal: true

class ProfilesController < ApplicationController
  def show
    @profile_info = retro_meet_client.profile_info
  end

  def edit
    @profile_info = retro_meet_client.profile_info
  end

  def update
    response = retro_meet_client.update_profile_info(profile_params)
    if response
      redirect_to profile_path, status: :see_other
    else
      @profile_info = ProfileInfo.new(**profile_params)
      render :edit, status: :unprocessable_content
    end
  end

  def view
    @profile_info = ProfileInfo.new
    render "show"
  end

  private

    def profile_params
      @profile_params ||= params.require(:profile).permit(*ProfileInfo.members).to_hash.transform_keys!(&:to_sym)
    end
end
