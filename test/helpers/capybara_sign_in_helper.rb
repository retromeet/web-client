# frozen_string_literal: true

module CapybaraSignInHelper
  def sign_in
    stubs = []
    stubs << stub_request(:post, "http://localhost:3000/login").to_return(webfixture_json_file("login_ok"))
    stubs << stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stubs << stub_request(:get, "http://localhost:3000/api/listing").to_return(webfixture_json_file("listing"))

    visit new_session_url

    fill_in("email", with: "blob@blob.com")
    fill_in("Password", with: "my-password")

    click_button("Sign in") # rubocop:disable Capybara/ClickLinkOrButtonStyle
    assert_text("Logged in successfully")

    stubs.each { |s| remove_request_stub(s) }
  end
end
