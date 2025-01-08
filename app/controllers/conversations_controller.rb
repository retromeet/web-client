# frozen_string_literal: true

class ConversationsController < ApplicationController
  def index
    @conversations = retro_meet_client.find_conversations
  end

  def create
    conversation_id = retro_meet_client.create_conversation(other_profile_id: params[:other_profile])
    redirect_to conversation_messages_path(conversation_id), status: :see_other
  end
end
