# frozen_string_literal: true

module Conversations
  class MessagesController < ApplicationController
    def show
      @basic_profile_info = basic_profile_info
      conversation = retro_meet_client.conversation(conversation_id: params[:conversation_id])
      @conversation = conversation.value
      @messages = conversation.messages
                              .value
      # (renatolond, 2024-11-25) This should probably be client-side with https://github.com/stimulus-use/stimulus-use/, but for the moment I'll put it here
      conversation.viewed!
    end

    def create
      conversation = retro_meet_client.conversation(conversation_id: params[:conversation_id])
      @conversation = conversation.value
      conversation.send_message(content: params[:message])
      @messages = conversation.messages(min_id: params[:min_id])
                              .value
    end
  end
end
