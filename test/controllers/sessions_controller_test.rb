require_relative "../test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "on create, should return auth token as a cookie" do
    email = "good@email.com"
    password = "good_password"
    RetroMeetClient.expects(:login).returns("good-token")
    post session_url(sessions: { email:, password: })
    assert_equal "good-token", cookies["Authorization"]
    assert_redirected_to root_path
  end
  test "on create, should fail with proper message on password error" do
    email = "good@email.com"
    password = "bad_password"
    RetroMeetClient.expects(:login).raises(RetroMeetClient::BadPasswordError)
    post session_url(sessions: { email:, password: })
  end
  test "on create, should fail with proper message on login error" do
    email = "bad@email.com"
    password = "password"
    RetroMeetClient.expects(:login).raises(RetroMeetClient::BadLoginError)
    post session_url(sessions: { email:, password: })
  end
end
