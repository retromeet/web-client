# frozen_string_literal: true

require_relative "../../test_helper"

class RetroMeetClientTest < ActiveSupport::TestCase
  test "calls the login method with good params and get an auth token" do
    login = "foo@bar.com"
    password = "bar"
    user_ip = "10.1.2.3"
    stub_request(:post, "http://localhost:3000/login").with(headers: { "Content-Type" => "application/json", "X-Forwarded-For": user_ip })
                                                      .to_return(webfixture_json_file("login_ok"))

    expected_response = "eyJhbGciOiJIUzI1NiJ9.eyJhY2NvdW50X2lkIjoxLCJhdXRoZW50aWNhdGVkX2J5IjpbInBhc3N3b3JkIl19.twCmKESFEIkjABPanrfnlU7mpVmrYsCqGIn_Z9oRJaE"
    RetroMeet::Core.connect(user_ip:) do |client|
      assert_equal expected_response, client.login(login:, password:)
    end
    assert_requested(:post, "http://localhost:3000/login")
  end

  test "calls the login method with a bad password and gets an error" do
    login = "foo@bar.com"
    password = "bad_password"
    user_ip = "10.1.2.3"
    stub_request(:post, "http://localhost:3000/login").with(headers: { "Content-Type" => "application/json" })
                                                      .to_return(webfixture_json_file("login_bad_password"))

    assert_raises RetroMeet::Core::UnauthorizedError do
      RetroMeet::Core.connect(user_ip:) do |client|
        client.login(login:, password:)
      end
    end
    assert_requested(:post, "http://localhost:3000/login")
  end

  test "calls the login method with a bad login and gets an error" do
    login = "bad_login@bad.com"
    password = "bad_password"
    user_ip = "10.1.2.3"
    stub_request(:post, "http://localhost:3000/login").with(headers: { "Content-Type" => "application/json" })
                                                      .to_return(webfixture_json_file("login_bad_login"))

    assert_raises RetroMeet::Core::UnauthorizedError do
      RetroMeet::Core.connect(user_ip:) do |client|
        client.login(login:, password:)
      end
    end
    assert_requested(:post, "http://localhost:3000/login")
  end

  test "calls the create_account method with good params and get an auth token" do
    login = "test@retromeet.social"
    password = "bar"
    user_ip = "10.1.2.3"
    stub_request(:post, "http://localhost:3000/create-account").with(headers: { "Content-Type" => "application/json", "X-Forwarded-For": user_ip })
                                                               .to_return(webfixture_json_file("create_account_ok"))

    expected_response = "eyJhbGciOiJIUzI1NiJ9.eyJhY2NvdW50X2lkIjoxNCwiYXV0aGVudGljYXRlZF9ieSI6WyJhdXRvbG9naW4iXSwiYXV0b2xvZ2luX3R5cGUiOiJjcmVhdGVfYWNjb3VudCJ9.Fo5ZXDASNTcea-V4KlX8JjWy7XQOcPHDFcjET0HeIsw"
    RetroMeet::Core.connect(user_ip:) do |client|
      assert_equal expected_response, client.create_account(login:, password:, birth_date: "1980-01-01")
    end
    assert_requested(:post, "http://localhost:3000/create-account")
  end
  test "calls the create_account method with good params but already used login and gets the proper error" do
    login = "test@retromeet.social"
    password = "bar"
    user_ip = "10.1.2.3"
    stub_request(:post, "http://localhost:3000/create-account").with(headers: { "Content-Type" => "application/json" })
                                                               .to_return(webfixture_json_file("create_account_existing"))

    assert_raises RetroMeet::Core::LoginAlreadyTakenError do
      RetroMeet::Core.connect(user_ip:) do |client|
        client.create_account(login:, password:, birth_date: "1980-01-01")
      end
    end
    assert_requested(:post, "http://localhost:3000/create-account")
  end
  test "calls the create_account method with a bad password and gets an error" do
    login = "test@retromeet.social"
    password = ""
    user_ip = "10.1.2.3"
    stub_request(:post, "http://localhost:3000/create-account").with(headers: { "Content-Type" => "application/json" })
                                                               .to_return(webfixture_json_file("create_account_bad_password"))

    assert_raises RetroMeet::Core::BadPasswordError do
      RetroMeet::Core.connect(user_ip:) do |client|
        client.create_account(login:, password:, birth_date: "1980-01-01")
      end
    end
    assert_requested(:post, "http://localhost:3000/create-account")
  end
  test "calls the create_account method with a bad login and gets an error" do
    login = "bad_login"
    password = "bad_password"
    user_ip = "10.1.2.3"
    stub_request(:post, "http://localhost:3000/create-account").with(headers: { "Content-Type" => "application/json" })
                                                               .to_return(webfixture_json_file("create_account_bad_login"))

    assert_raises RetroMeet::Core::BadLoginError do
      RetroMeet::Core.connect(user_ip:) do |client|
        client.create_account(login:, password:, birth_date: "1980-01-01")
      end
    end
    assert_requested(:post, "http://localhost:3000/create-account")
  end

  test "calls the profile info method with a good authorization header and gets the profile info" do
    authorization_header = "good_header"
    user_ip = "10.1.2.3"
    stub_request(:get, "http://localhost:3000/api/profile/info").with(headers: { "Authorization" => authorization_header, "X-Forwarded-For": user_ip })
                                                                .to_return(webfixture_json_file("profile_info_good"))
    expected_response = BasicProfileInfo.new("0192e1e9-9e3a-7156-91c3-6e38966821eb", "bob tables", DateTime.new(2024, 9, 23, 15, 45, 24, "+02:00"))
    RetroMeet::Core.connect(user_ip:, authorization_header:) do |client|
      assert_equal expected_response, client.basic_profile_info.value
    end
    assert_requested(:get, "http://localhost:3000/api/profile/info")
  end
end
