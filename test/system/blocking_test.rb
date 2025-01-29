# frozen_string_literal: true

require_relative "../application_system_test_case"

class BlockingTest < ApplicationSystemTestCase
  test "block a user" do
    sign_in

    other_profile_uuid = "11111111-1111-7111-b111-111111111111"

    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/profile/#{other_profile_uuid}/complete").to_return(webfixture_json_file("other_profile_complete_good"))

    visit view_profile_url(other_profile_uuid)

    assert_link("Send them a message")
    assert_link("Block their profile")

    stub_request(:post, "http://localhost:3000/api/profile/#{other_profile_uuid}/block").to_return(webfixture_json_file("block_good"))
    stub_request(:get, "http://localhost:3000/api/listing?max_distance=#{RetroMeet::Core::Listing::DEFAULT_MAX_DISTANCE_IN_KM}").to_return(webfixture_json_file("listing"))

    click_on "Block their profile"

    assert_text "Go to profile"
  end
  test "unblock a user" do
    sign_in

    other_profile_uuid = "11111111-1111-7111-b111-111111111111"

    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    profile_stub = stub_request(:get, "http://localhost:3000/api/profile/#{other_profile_uuid}/complete").to_return(webfixture_json_file("other_profile_complete_blocked"))

    visit view_profile_url(other_profile_uuid)

    remove_request_stub(profile_stub)
    assert_link("Send them a message")
    assert_link("Unblock their profile")

    stub_request(:delete, "http://localhost:3000/api/profile/#{other_profile_uuid}/block").to_return(webfixture_json_file("unblock_good"))
    stub_request(:get, "http://localhost:3000/api/listing?max_distance=#{RetroMeet::Core::Listing::DEFAULT_MAX_DISTANCE_IN_KM}").to_return(webfixture_json_file("listing"))
    stub_request(:get, "http://localhost:3000/api/profile/#{other_profile_uuid}/complete").to_return(webfixture_json_file("other_profile_complete_good"))

    click_on "Unblock their profile"

    assert_link("Send them a message")
    assert_link("Block their profile")
  end
end
