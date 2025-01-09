# frozen_string_literal: true

require "test_helper"

module Conversations
  class MessagesControllerTest < ActionDispatch::IntegrationTest
    include ControllerAuthorizationHelper
    test "create a message" do
      set_authorization_headers
      stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))

      stub_request(:get, "http://localhost:3000/api/conversations/11111111-1111-7111-b111-111111111111").to_return(webfixture_json_file("single_conversation_good"))
      stub_request(:post, "http://localhost:3000/api/conversations/11111111-1111-7111-b111-111111111111/messages")
        .with(body: "{\"content\":\"Hello, friend!\"}")
        .to_return(webfixture_json_file("send_message_good"))

      stub_request(:get, "http://localhost:3000/api/conversations/11111111-1111-7111-b111-111111111111/messages").with(query: { min_id: 18 })
                                                                                                                 .to_return(webfixture_json_file("messages_good"))

      post conversation_messages_url(conversation_id: "11111111-1111-7111-b111-111111111111"), params: { message: "Hello, friend!", min_id: 18 }, xhr: true
      assert_response :success
    end
  end
end
