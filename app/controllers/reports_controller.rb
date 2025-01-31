# frozen_string_literal: true

class ReportsController < ApplicationController
  def create
    retro_meet_client.reports.create(target_profile_id: params[:target_profile_id],
                                     type: params[:type],
                                     comment: params[:comment],
                                     message_ids: params[:messages])
  end

  def wizard_step1
    conversation = retro_meet_client.other_profile(other_profile_id: params[:target_profile_id])
                                    .conversation
    if conversation
      @messages = retro_meet_client.conversation(conversation_id: conversation.id)
                                   .messages
                                   .value
                                   .select { |v| v.sender == params[:target_profile_id] }
    end

    if @messages.present?
      render "wizard_step1"
    else
      render "wizard_step2"
    end
  end
end
