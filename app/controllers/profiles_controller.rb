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
    @profile_info = retro_meet_client.other_profile_info(id: params[:id])
    render "show"
  end

  private

    # This is mostly +ProfileInfo.members+, but not completely, for any param that is an array it needs to be described separately
    PROFILE_FIELDS = [:display_name,
                      :profile_picture,
                      :location,
                      :about_me,
                      :pronouns,
                      :relationship_status,
                      :relationship_type,
                      :tobacco,
                      :alcohol,
                      :marijuana,
                      :other_recreational_drugs,
                      :kids,
                      :wants_kids,
                      :pets,
                      :wants_pets,
                      :religion,
                      :religion_importance,
                      :hide_age,
                      { languages: [], genders: [], orientations: [] }].freeze
    def profile_params
      @profile_params ||= params.require(:profile).permit(*PROFILE_FIELDS).to_hash.transform_keys!(&:to_sym)
    end
end
