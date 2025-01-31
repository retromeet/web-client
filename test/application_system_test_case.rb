require "test_helper"
require_relative "helpers/capybara_sign_in_helper"

Capybara.configure do |config|
  config.server = :falcon_http
  config.enable_aria_label = true
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include CapybaraSignInHelper

  headless = ENV.fetch("HEADLESS", true) != "false"

  driven_by(:selenium, using: :chrome, screen_size: [1400, 1400]) do |driver|
    driver.add_argument("--headless") if headless
    driver.add_argument("--no-sandbox")
    driver.add_argument("--disable-dev-shm-usage")
    driver.add_argument("--disable-gpu")
  end
end
