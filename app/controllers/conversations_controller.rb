# frozen_string_literal: true

class ConversationsController < ApplicationController
  def show
    @conversations = retro_meet_client.find_conversations
  end
end
