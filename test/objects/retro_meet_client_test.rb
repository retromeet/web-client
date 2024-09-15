# frozen_string_literal: true

require_relative "../test_helper"

class RetroMeetClientTest < ActiveSupport::TestCase
  test "calls the login method with good params and get an auth token" do
    login = "foo@bar.com"
    password = "bar"
    stub_request(:post, "http://localhost:3000/login").with(headers: { "Content-Type" => "application/json" })
                                                      .to_return(webfixture_json_file("login_ok"))

    expected_response = "eyJhbGciOiJIUzI1NiJ9.eyJhY2NvdW50X2lkIjoxLCJhdXRoZW50aWNhdGVkX2J5IjpbInBhc3N3b3JkIl19.twCmKESFEIkjABPanrfnlU7mpVmrYsCqGIn_Z9oRJaE"
    assert_equal expected_response, RetroMeetClient.login(login:, password:)
    assert_requested(:post, "http://localhost:3000/login")
  end
  test "calls the login method with a bad password and gets an error" do
    login = "foo@bar.com"
    password = "bad_password"
    stub_request(:post, "http://localhost:3000/login").with(headers: { "Content-Type" => "application/json" })
                                                      .to_return(webfixture_json_file("login_bad_password"))

    assert_raises RetroMeetClient::UnauthorizedError do
      RetroMeetClient.login(login:, password:)
    end
    assert_requested(:post, "http://localhost:3000/login")
  end
  test "calls the login method with a bad login and gets an error" do
    login = "bad_login@bad.com"
    password = "bad_password"
    stub_request(:post, "http://localhost:3000/login").with(headers: { "Content-Type" => "application/json" })
                                                      .to_return(webfixture_json_file("login_bad_login"))

    assert_raises RetroMeetClient::UnauthorizedError do
      RetroMeetClient.login(login:, password:)
    end
    assert_requested(:post, "http://localhost:3000/login")
  end
end
