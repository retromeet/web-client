# frozen_string_literal: true

# Contains method to help in Capybara tests
module CapybaraSignInHelper
  # Signs a user in. Will stub a few requests, but will unstub them before the test is over.
  def sign_in
    visit root_url
    cookie_jar = ActionDispatch::Request.new(
      Rails.application.env_config.deep_dup
    ).cookie_jar

    cookie_jar.signed[:session] = { value: { "token" => "TOKEN", "refresh_token" => "REFRESH_TOKEN", "expires_at" => 1.hour.from_now, "expires" => true } }
    page.driver.browser.manage.add_cookie(name: "session", value: Rack::Utils.escape(cookie_jar[:session]))
  end
end
