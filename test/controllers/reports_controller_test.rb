# frozen_string_literal: true

require_relative "../test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include ControllerAuthorizationHelper

  test "should create" do
    set_authorization_headers
    stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))

    stub_request(:post, "http://localhost:3000/api/reports")
      .with(body: "{\"target_profile_id\":\"11111111-1111-7111-b111-111111111111\",\"type\":\"spam\",\"comment\":\"They are trying to sell me some soap!?\",\"message_ids\":null}")
      .to_return(webfixture_json_file("reports_good"))

    post reports_url, params: { target_profile_id: "11111111-1111-7111-b111-111111111111", type: "spam", comment: "They are trying to sell me some soap!?" }, xhr: true

    assert_response :success
  end
end
