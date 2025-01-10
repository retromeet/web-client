# frozen_string_literal: true

require_relative "../application_system_test_case"

class ProfileTest < ApplicationSystemTestCase
  test "Sees own profile" do
    sign_in

    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/profile/complete").to_return(webfixture_json_file("profile_complete_good"))
    stub_request(:get, "http://localhost:3000/api/images/eyJpZCI6InByb2ZpbGVfcGljdHVyZS8wMTkyYjg5Yi04NTE4LTdlMTYtYmQ1YS00OWU3MWY4MWI0NzcvNWU0N2I4ZDk3NTI3OTU2ZGZhZDQwMWM4YTlhMzI2MWIuanBlZyIsInN0b3JhZ2UiOiJzdG9yZSIsIm1ldGFkYXRhIjp7ImZpbGVuYW1lIjoiRmFjZS5qcGVnIiwic2l6ZSI6MjQ3MjM2LCJtaW1lX3R5cGUiOiJpbWFnZS9qcGVnIn19").to_return(webfixture_file("profile_image.bin"))

    visit profile_url

    assert_link("Edit profile")
    assert_link("Edit profile location")
    assert_link("Edit profile picture")
  end

  test "Edits own profile" do
    sign_in
    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/profile/complete").to_return(webfixture_json_file("profile_complete_good"))
    stub_request(:get, "http://localhost:3000/api/images/eyJpZCI6InByb2ZpbGVfcGljdHVyZS8wMTkyYjg5Yi04NTE4LTdlMTYtYmQ1YS00OWU3MWY4MWI0NzcvNWU0N2I4ZDk3NTI3OTU2ZGZhZDQwMWM4YTlhMzI2MWIuanBlZyIsInN0b3JhZ2UiOiJzdG9yZSIsIm1ldGFkYXRhIjp7ImZpbGVuYW1lIjoiRmFjZS5qcGVnIiwic2l6ZSI6MjQ3MjM2LCJtaW1lX3R5cGUiOiJpbWFnZS9qcGVnIn19").to_return(webfixture_file("profile_image.bin"))

    stub_request(:post, "http://localhost:3000/api/profile/complete").with(body: "{\"about_me\":\"HEY WHAT DOES THIS DO?\",\"relationship_status\":\"single\",\"relationship_type\":\"non_monogamous\",\"tobacco\":\"never\",\"alcohol\":\"sometimes\",\"marijuana\":\"sometimes\",\"other_recreational_drugs\":null,\"kids\":\"have_not\",\"wants_kids\":\"do_not_want_any\",\"pets\":\"have\",\"wants_pets\":\"maybe\",\"religion\":\"atheism\",\"religion_importance\":\"not_important\",\"hide_age\":\"0\",\"languages\":[\"eng\"],\"genders\":[\"man\"],\"orientations\":[\"bisexual\"]}")
                                                                     .to_return(webfixture_json_file("update_profile_ok"))

    visit edit_profile_url

    assert_unchecked_field("Hide age")

    select("Single", from: "Relationship status")
    click_on("Update Profile")

    assert_link("Edit profile")
  end
end
