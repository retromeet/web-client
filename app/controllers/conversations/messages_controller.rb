# frozen_string_literal: true

module Conversations
  class MessagesController < ApplicationController
    def show
      @basic_profile_info = basic_profile_info
      @conversation = retro_meet_client.find_conversation(conversation_id: params[:conversation_id])
      @messages = retro_meet_client.find_messages(conversation_id: @conversation.id).reverse
    end

    def create
      @conversation = retro_meet_client.find_conversation(conversation_id: params[:conversation_id])
      retro_meet_client.send_message(conversation_id: @conversation.id, content: params[:message])
      @messages = retro_meet_client.find_messages(conversation_id: @conversation.id, min_id: params[:min_id]).reverse
    end
  end
end
