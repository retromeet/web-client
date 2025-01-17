# frozen_string_literal: true

require "test_helper"

module Profiles
  class LocationsControllerTest < ActionDispatch::IntegrationTest
    include ControllerAuthorizationHelper

    test "update the profile location" do
      set_authorization_headers
      stub_request(:get, "http://localhost:3000/api/profile/info").to_return(webfixture_json_file("profile_info_good"))
      stub_request(:post, "http://localhost:3000/api/profile/location").with(body: "{\"location\":\"Eixample, Barcelona, Catalonia, Spain\",\"osm_id\":\"3008998\"}")
                                                                       .to_return(webfixture_json_file("location_update_good"))

      patch profile_location_url, params: { location: "Eixample, Barcelona, Catalonia, Spain|3008998" }, xhr: true
      assert_response :see_other
    end
  end
end
