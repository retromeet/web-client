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

  test "Edits profile location, with multiple results" do
    sign_in
    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/profile/complete").to_return(webfixture_json_file("profile_complete_good"))
    stub_request(:get, "http://localhost:3000/api/images/eyJpZCI6InByb2ZpbGVfcGljdHVyZS8wMTkyYjg5Yi04NTE4LTdlMTYtYmQ1YS00OWU3MWY4MWI0NzcvNWU0N2I4ZDk3NTI3OTU2ZGZhZDQwMWM4YTlhMzI2MWIuanBlZyIsInN0b3JhZ2UiOiJzdG9yZSIsIm1ldGFkYXRhIjp7ImZpbGVuYW1lIjoiRmFjZS5qcGVnIiwic2l6ZSI6MjQ3MjM2LCJtaW1lX3R5cGUiOiJpbWFnZS9qcGVnIn19").to_return(webfixture_file("profile_image.bin"))
    stub_request(:post, "http://localhost:3000/api/search/address?query=Scranton").to_return(webfixture_json_file("search_multiple_results"))
    stub_request(:post, "http://localhost:3000/api/profile/location").to_return(webfixture_json_file("location_update_good"))
    visit edit_profile_location_url

    assert_text "Change your location"

    fill_in "Location name", with: "Scranton"
    click_on "Search"

    assert_field "Scranton, Logan County, Arkansas, United States of America (City)"
    assert_field "Scranton, Lackawanna County, Pennsylvania, United States of America (City)"

    choose "Scranton, Lackawanna County, Pennsylvania, United States of America (City)"
    click_on "Save"
    assert_link("Edit profile")
  end

  test "Edits profile location, with only one result" do
    sign_in
    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/profile/complete").to_return(webfixture_json_file("profile_complete_good"))
    stub_request(:get, "http://localhost:3000/api/images/eyJpZCI6InByb2ZpbGVfcGljdHVyZS8wMTkyYjg5Yi04NTE4LTdlMTYtYmQ1YS00OWU3MWY4MWI0NzcvNWU0N2I4ZDk3NTI3OTU2ZGZhZDQwMWM4YTlhMzI2MWIuanBlZyIsInN0b3JhZ2UiOiJzdG9yZSIsIm1ldGFkYXRhIjp7ImZpbGVuYW1lIjoiRmFjZS5qcGVnIiwic2l6ZSI6MjQ3MjM2LCJtaW1lX3R5cGUiOiJpbWFnZS9qcGVnIn19").to_return(webfixture_file("profile_image.bin"))
    stub_request(:post, "http://localhost:3000/api/search/address?query=Eixample,%2008013%20Barcelona,%20Espanha").to_return(webfixture_json_file("search_single_result"))
    stub_request(:post, "http://localhost:3000/api/profile/location").to_return(webfixture_json_file("location_update_good"))
    visit edit_profile_location_url

    assert_text "Change your location"

    fill_in "Location name", with: "Eixample, 08013 Barcelona, Espanha"
    click_on "Search"

    assert_field "Location", with: "Eixample, Barcelona, Catalonia, Spain", disabled: true
    click_on "Save"
    assert_link("Edit profile")
  end

  test "Update profile picture" do
    sign_in
    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/profile/complete").to_return(webfixture_json_file("profile_complete_good"))
    stub_request(:get, "http://localhost:3000/api/images/eyJpZCI6InByb2ZpbGVfcGljdHVyZS8wMTkyYjg5Yi04NTE4LTdlMTYtYmQ1YS00OWU3MWY4MWI0NzcvNWU0N2I4ZDk3NTI3OTU2ZGZhZDQwMWM4YTlhMzI2MWIuanBlZyIsInN0b3JhZ2UiOiJzdG9yZSIsIm1ldGFkYXRhIjp7ImZpbGVuYW1lIjoiRmFjZS5qcGVnIiwic2l6ZSI6MjQ3MjM2LCJtaW1lX3R5cGUiOiJpbWFnZS9qcGVnIn19").to_return(webfixture_file("profile_image.bin"))
    visit edit_profile_picture_url

    assert_text("Here you can change your profile picture")

    page.find_by_id("profile_picture", visible: false).attach_file File.absolute_path("./test/fixtures/files/fake_face.jpg")

    # TODO: Create a test to validate the call itself
    stub_request(:post, "http://localhost:3000/api/profile/picture").to_return(webfixture_json_file("upload_file_ok"))
    click_on "Upload picture"
    assert_link("Edit profile picture")
  end

  test "checks someone else's profile" do
    sign_in

    other_profile_uuid = "11111111-1111-7111-b111-111111111111"

    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/profile/#{other_profile_uuid}/complete").to_return(webfixture_json_file("other_profile_complete_good"))

    visit view_profile_url(other_profile_uuid)

    assert_link("Send them a message")
    assert_button("More actions")
  end
end
