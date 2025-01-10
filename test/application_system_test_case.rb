require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  headless = ENV.fetch("HEADLESS", true) != "false"

  driven_by(:selenium, using: :chrome, screen_size: [1400, 1400]) do |driver|
    driver.add_argument("--headless") if headless
    driver.add_argument("--no-sandbox")
    driver.add_argument("--disable-dev-shm-usage")
    driver.add_argument("--disable-gpu")
  end
end
