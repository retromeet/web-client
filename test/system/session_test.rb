# frozen_string_literal: true

require_relative "../application_system_test_case"

class SessionTest < ApplicationSystemTestCase
  def fill_in_fields
    fill_in("email", with: "blob@blob.com")
    fill_in("Password", with: "my-password")
    click_button("Sign in") # rubocop:disable Capybara/ClickLinkOrButtonStyle
  end

  test "Logging in to a good account" do
    stub_request(:post, "http://localhost:3000/login").to_return(webfixture_json_file("login_ok"))
    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/listing").to_return(webfixture_json_file("listing"))

    visit new_session_url

    fill_in_fields

    assert_text("Logged in successfully")
  end
  test "Logging in with bad login" do
    stub_request(:post, "http://localhost:3000/login").to_return(webfixture_json_file("login_bad_login"))

    visit new_session_url

    fill_in_fields

    assert_text("Incorrect login. It should be the e-mail you used to sign-in.")
  end
  test "Logging in with bad password" do
    stub_request(:post, "http://localhost:3000/login").to_return(webfixture_json_file("login_bad_password"))

    visit new_session_url

    fill_in_fields

    assert_text("Incorrect password")
  end
end
