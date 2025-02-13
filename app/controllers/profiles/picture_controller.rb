# frozen_string_literal: true

module Profiles
  class PictureController < ApplicationController
    def edit
      @profile_info = retro_meet_client.profile_info
                                       .value
    end

    def update
      if params[:profile_picture].nil?
        flash[:error] = t(".missing_profile_picture")
        redirect_to edit_profile_picture_path, status: :see_other
      else
        retro_meet_client.profile_picture.upload(filename: params[:profile_picture].original_filename,
                                                 io: params[:profile_picture].to_io,
                                                 content_type: params[:profile_picture].content_type)
        redirect_to profile_path, status: :see_other
      end
    end
  end
end
