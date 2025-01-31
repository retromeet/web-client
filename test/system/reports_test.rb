# frozen_string_literal: true

require_relative "../application_system_test_case"

class ReportTest < ApplicationSystemTestCase
  test "Report a user that has no conversations" do
    sign_in

    other_profile_uuid = "11111111-1111-7111-b111-111111111111"

    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/profile/#{other_profile_uuid}/complete").to_return(webfixture_json_file("other_profile_complete_good"))

    visit view_profile_url(other_profile_uuid)

    assert_link("Send them a message")

    click_on "More actions"

    stub_request(:get, "http://localhost:3000/api/profile/#{other_profile_uuid}/conversation").to_return(webfixture_json_file("profile_conversation_not_found"))

    assert_link("Report their profile")
    click_on "Report their profile"

    assert_text "Why are you reporting this profile?"
    click_on "Spam"

    assert_text "Why you are making this report? (this step is optional)"
    click_on "Continue"

    stub_request(:post, "http://localhost:3000/api/reports")
      .with(body: "{\"target_profile_id\":\"11111111-1111-7111-b111-111111111111\",\"type\":\"spam\",\"comment\":\"\",\"message_ids\":null}")
      .to_return(status: 204)

    assert_text "Your report was created and will be checked by someone in our staff!"
    click_on "Close window"

    assert_link("Send them a message")
  end
  test "Report a user that has a conversation, but no messages" do
    sign_in

    other_profile_uuid = "11111111-1111-7111-b111-111111111111"

    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/profile/#{other_profile_uuid}/complete").to_return(webfixture_json_file("other_profile_complete_good"))

    visit view_profile_url(other_profile_uuid)

    assert_link("Send them a message")

    click_on "More actions"

    stub_request(:get, "http://localhost:3000/api/profile/#{other_profile_uuid}/conversation").to_return(webfixture_json_file("profile_conversation_good"))
    stub_request(:get, "http://localhost:3000/api/conversations/11111111-1111-7111-b111-111111111111/messages").to_return(webfixture_json_file("messages_empty_good"))

    assert_link("Report their profile")
    click_on "Report their profile"

    assert_text "Why are you reporting this profile?"
    click_on "Spam"

    assert_text "Why you are making this report? (this step is optional)"
    fill_in "comment", with: "They are trying to sell me soap?!"

    click_on "Continue"

    stub_request(:post, "http://localhost:3000/api/reports")
      .with(body: "{\"target_profile_id\":\"11111111-1111-7111-b111-111111111111\",\"type\":\"spam\",\"comment\":\"They are trying to sell me soap?!\",\"message_ids\":null}")
      .to_return(status: 204)

    assert_text "Your report was created and will be checked by someone in our staff!"
    click_on "Close window"

    assert_link("Send them a message")
  end

  test "Report a user that has a conversation and some messages" do
    sign_in

    other_profile_uuid = "11111111-1111-7111-b111-111111111111"

    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/profile/#{other_profile_uuid}/complete").to_return(webfixture_json_file("other_profile_complete_good"))

    visit view_profile_url(other_profile_uuid)

    assert_link("Send them a message")

    click_on "More actions"

    stub_request(:get, "http://localhost:3000/api/profile/#{other_profile_uuid}/conversation").to_return(webfixture_json_file("profile_conversation_good"))
    stub_request(:get, "http://localhost:3000/api/conversations/11111111-1111-7111-b111-111111111111/messages").to_return(webfixture_json_file("messages_good"))

    assert_link("Report their profile")
    click_on "Report their profile"

    assert_text "We found some messages to you from the profile you are reporting"

    check "Hey, bud!"

    click_on "Continue"

    assert_text "Why are you reporting this profile?"
    click_on "Spam"

    assert_text "Why you are making this report? (this step is optional)"
    fill_in "comment", with: "They are trying to sell me soap?!"

    click_on "Continue"

    stub_request(:post, "http://localhost:3000/api/reports")
      .with(body: "{\"target_profile_id\":\"11111111-1111-7111-b111-111111111111\",\"type\":\"spam\",\"comment\":\"They are trying to sell me soap?!\",\"message_ids\":[\"17\"]}")
      .to_return(status: 204)

    assert_text "Your report was created and will be checked by someone in our staff!"
    click_on "Close window"

    assert_link("Send them a message")
  end
end
