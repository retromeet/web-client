# frozen_string_literal: true

class ReportsController < ApplicationController
  def create
    retro_meet_client.reports.create(target_profile_id: params[:target_profile_id],
                                     type: params[:type],
                                     comment: params[:comment],
                                     message_ids: params[:message_ids])
  end
end
