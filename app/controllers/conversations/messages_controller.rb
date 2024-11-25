# frozen_string_literal: true

module Conversations
  class MessagesController < ApplicationController
    def show
      @basic_profile_info = basic_profile_info
      @conversation = retro_meet_client.find_conversation(conversation_id: params[:conversation_id])
      @messages = retro_meet_client.find_messages(conversation_id: @conversation.id).reverse
      # (renatolond, 2024-11-25) This should probably be client-side with https://github.com/stimulus-use/stimulus-use/, but for the moment I'll put it here
      retro_meet_client.conversation_viewed(conversation_id: @conversation.id)
    end

    def create
      @conversation = retro_meet_client.find_conversation(conversation_id: params[:conversation_id])
      retro_meet_client.send_message(conversation_id: @conversation.id, content: params[:message])
      @messages = retro_meet_client.find_messages(conversation_id: @conversation.id, min_id: params[:min_id]).reverse
    end
  end
end
