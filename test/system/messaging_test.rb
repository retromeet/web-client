# frozen_string_literal: true

require_relative "../application_system_test_case"

class MessagingTest < ApplicationSystemTestCase
  test "Visit an empty conversation list" do
    sign_in

    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/conversations").to_return(webfixture_json_file("conversations_empty_good"))

    visit conversations_url

    assert_text("Currently you have no messages")
  end
  test "Visit a conversation list with a few conversations" do
    sign_in

    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/conversations").to_return(webfixture_json_file("conversations_good"))

    visit conversations_url

    assert_text("johnny")
    assert_text("bob")

    click_on("johnny")
  end
  test "see correct error" do
    sign_in
    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    visit conversation_messages_url("11111111-1111-7111-b111-111111111111")
  end
end
