# frozen_string_literal: true

require_relative "../test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "on create, should return auth token as a cookie" do
    email = "good@email.com"
    password = "good_password"
    RetroMeet::Core::Login.any_instance.expects(:login).with(email, password).returns("good-token")
    post session_url(email:, password:)
    jar = ActionDispatch::Cookies::CookieJar.build(request, cookies.to_hash)
    assert_equal "good-token", jar.signed["authorization"]
    assert_redirected_to root_path
  end
end
