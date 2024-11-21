# frozen_string_literal: true

module Conversations
  class MessagesController < ApplicationController
    def show
      @basic_profile_info = basic_profile_info
      # TODO: everything here is a placeholder, make it real
      @conversation = retro_meet_client.find_conversations.first
      @messages = [
        Message.new(basic_profile_info.id, DateTime.new(2024, 10, 1), "Hey, saw your profile and it looks like we could get along, how are you?"),
        Message.new("0192e1e9-4c48-7be4-9f0a-30025f27f4ca", DateTime.now, "Hey, how are you?"),
        Message.new("0192e1e9-4c48-7be4-9f0a-30025f27f4ca", DateTime.now, "Just saw your messages"),
        Message.new("0192e1e9-4c48-7be4-9f0a-30025f27f4ca", DateTime.now, "Can't wait to get a drink with ya!")
      ]
    end
  end
end
