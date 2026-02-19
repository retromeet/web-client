# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require "webmock/minitest"
require "mocha/minitest"

# Checks if a request that got to webmock is probably made by selenium.
# @return [Boolean] Description
def selenium_request?(request)
  return false if "#{request.uri.scheme}://#{request.uri.host}:#{request.uri.port}/" == Rails.configuration.x.retromeet_core_host

  request.headers["User-Agent"].match?(%r{^selenium/}i) || (
    # The selenium driver sends a final "shutdown" request where the user
    # agent header is wrong, so allow that too.
    request.uri.host == "127.0.0.1" &&
    ["/shutdown", "/__identify__", "/status"].include?(request.uri.path) &&
    request.headers["User-Agent"] == "Ruby"
  )
end

WebMock::StubRegistry.instance.reset!
WebMock.disable_net_connect!(allow: [->(uri) { WebMock::Util::URI.is_uri_localhost?(uri) && "#{uri.scheme}://#{uri.host}:#{uri.port}/" != Rails.configuration.x.retromeet_core_host }])
WebMock.stub_request(:any, //)
       .with { |request| !selenium_request?(request) }
       .to_return { |req| raise WebMock::NetConnectNotAllowedError.new(WebMock::RequestSignature.new(req.method, req.uri, body: req.body, headers: req.headers)) } # rubocop:disable Style/RaiseArgs

require_relative "helpers/cookie_jar_proxy"
require_relative "helpers/controller_authorization_helper"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Add more helper methods to be used by all tests here...

    # @param filename [String] The filename to read from, with the extension
    # @return (see File.open)
    def webfixture_file(filename) = Rails.root.join("test", "webfixtures", filename).open

    # @param filename [String] The filename to read from, without the extension, .json will be added
    # @return (see .webfixture_file)
    def webfixture_json_file(filename) = webfixture_file("#{filename}.json")
  end
end
