# frozen_string_literal: true

require_relative "../application_system_test_case"

class AccountCreationTest < ApplicationSystemTestCase
  def fill_in_fields(birth_date: Date.new(1997, 1, 1))
    fill_in("email", with: "blob@blob.com")
    fill_in("Password", with: "my-password")
    fill_in("Password confirmation", with: "my-password")
    fill_in("birth_date", with: birth_date)
    click_on("Sign up")
  end

  test "creating a new account" do
    stub_request(:post, "http://localhost:3000/create-account").to_return(webfixture_json_file("create_account_ok"))
    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
    stub_request(:get, "http://localhost:3000/api/listing").to_return(webfixture_json_file("listing"))

    visit new_account_session_url

    fill_in_fields

    assert_text("Your account was created")
  end
  test "creating a new account, fails because it exists" do
    stub_request(:post, "http://localhost:3000/create-account").to_return(webfixture_json_file("create_account_existing"))

    visit new_account_session_url

    fill_in_fields

    assert_text("The login is already in use.")
  end
  test "creating a new account, fails because of a bad login" do
    stub_request(:post, "http://localhost:3000/create-account").to_return(webfixture_json_file("create_account_bad_login"))

    visit new_account_session_url

    fill_in_fields

    assert_text("Your login must be a valid email.")
  end
  test "creating a new account, fails because it's too young" do
    visit new_account_session_url

    fill_in_fields(birth_date: Time.zone.today)

    assert_text("You need to be at least 18 years old to join")
  end
end
