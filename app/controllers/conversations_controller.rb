# frozen_string_literal: true

class ConversationsController < ApplicationController
  def index
    @conversations = retro_meet_client.find_conversations
  end

  def create
    retro_meet_client.create_conversation(other_profile_id: params[:other_profile])
  end
end
