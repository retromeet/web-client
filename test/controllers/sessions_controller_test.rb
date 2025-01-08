require_relative "../test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "on create, should return auth token as a cookie" do
    email = "good@email.com"
    password = "good_password"
    RetroMeet::Client.expects(:login).returns("good-token")
    post session_url(sessions: { email:, password: })
    jar = ActionDispatch::Cookies::CookieJar.build(request, cookies.to_hash)
    assert_equal "good-token", jar.signed["authorization"]
    assert_redirected_to root_path
  end
  test "on create, should fail with proper message on password error" do
    email = "good@email.com"
    password = "bad_password"
    RetroMeet::Client.expects(:login).raises(RetroMeet::Client::BadPasswordError)
    post session_url(sessions: { email:, password: })
  end
  test "on create, should fail with proper message on login error" do
    email = "bad@email.com"
    password = "password"
    RetroMeet::Client.expects(:login).raises(RetroMeet::Client::BadLoginError)
    post session_url(sessions: { email:, password: })
  end
end
