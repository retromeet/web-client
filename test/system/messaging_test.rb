# frozen_string_literal: true

require_relative "../application_system_test_case"

class MessagingTest < ApplicationSystemTestCase
  test "Start a conversation" do
    sign_in

    other_profile_uuid = "11111111-1111-7111-b111-111111111110"

    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:post, "http://localhost:3000/api/conversations").with(body: "{\"other_profile_id\":\"11111111-1111-7111-b111-111111111111\"}").to_return(webfixture_json_file("conversations_create_good"))
    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/profile/#{other_profile_uuid}/complete").to_return(webfixture_json_file("other_profile_complete_good"))

    visit view_profile_url(other_profile_uuid)
    assert_link "Send them a message"

    stub_request(:get, "http://localhost:3000/api/conversations/11111111-1111-7111-b111-111111111111").to_return(webfixture_json_file("single_conversation_good"))
    stub_request(:get, "http://localhost:3000/api/conversations/11111111-1111-7111-b111-111111111111/messages").to_return(webfixture_json_file("messages_empty_good"))
    stub_request(:put, "http://localhost:3000/api/conversations/11111111-1111-7111-b111-111111111111/viewed").to_return(status: 204)
    click_on "Send them a message"
    assert_text("Chat with johnny")
  end

  test "Visit an empty conversation list" do
    sign_in

    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/conversations").to_return(webfixture_json_file("conversations_empty_good"))

    visit conversations_url

    assert_text("Currently you have no messages")
  end
  test "Visit a conversation list with a few conversations and click on one of them" do
    sign_in

    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/conversations").to_return(webfixture_json_file("conversations_good"))
    stub_request(:get, "http://localhost:3000/api/conversations/11111111-1111-7111-b111-111111111111").to_return(webfixture_json_file("single_conversation_good"))
    stub_request(:get, "http://localhost:3000/api/conversations/11111111-1111-7111-b111-111111111111/messages").to_return(webfixture_json_file("messages_empty_good"))
    stub_request(:put, "http://localhost:3000/api/conversations/11111111-1111-7111-b111-111111111111/viewed").to_return(status: 204)

    visit conversations_url

    assert_text("johnny")
    assert_text("bob")

    click_on("johnny")

    assert_text("Chat with johnny")
  end
  test "Send a message" do
    sign_in

    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/conversations/11111111-1111-7111-b111-111111111111").to_return(webfixture_json_file("single_conversation_good"))
    messages_stub = stub_request(:get, "http://localhost:3000/api/conversations/11111111-1111-7111-b111-111111111111/messages").to_return(webfixture_json_file("messages_empty_good"))
    stub_request(:put, "http://localhost:3000/api/conversations/11111111-1111-7111-b111-111111111111/viewed").to_return(status: 204)
    visit conversation_messages_url("11111111-1111-7111-b111-111111111111")

    assert_text "There are no messages in this conversation at the moment"
    remove_request_stub(messages_stub)

    stub_request(:post, "http://localhost:3000/api/conversations/11111111-1111-7111-b111-111111111111/messages")
      .to_return(webfixture_json_file("send_message_good"))
    stub_request(:get, "http://localhost:3000/api/conversations/11111111-1111-7111-b111-111111111111/messages")
      .to_return(webfixture_json_file("messages_good"))
    fill_in "message", with: "Hello, friend"
    click_on("Send")

    assert_text "Hello, friend"
  end
end
