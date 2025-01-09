# frozen_string_literal: true

# Integration tests (and request specs) provide a Rack::Test::CookieJar, which
# does not support signed and encrypted cookies. This provides a couple methods
# to work around that, so request specs can set signed/encrypted cookies
# transparently.
module CookieJarProxy
  # @return [Proxy]
  def signed_cookies
    @signed_cookies ||= Proxy.new(action_dispatch_cookie_jar, :signed, cookies)
  end

  # @return [Proxy]
  def encrypted_cookies
    @encrypted_cookies ||= Proxy.new(action_dispatch_cookie_jar, :encrypted, cookies)
  end

  private

    # @return [ActionDispatch::Cookies::CookieJar]
    def action_dispatch_cookie_jar
      @action_dispatch_cookie_jar ||= ActionDispatch::Request.new(
        Rails.application.env_config.deep_dup
      ).cookie_jar
    end

    # A delegator for the rails cookie classes
    class Proxy < SimpleDelegator
      def initialize(rails_jar, type, rack_test_jar)
        super(rails_jar.send(type))
        @base_jar = rails_jar
        @rack_test_jar = rack_test_jar
      end

      # @see Rack::Test::CookieJar#[]=
      def []=(cookie, value)
        super
        @rack_test_jar[cookie] = @base_jar[cookie]
      end
    end
end

ActiveSupport.on_load(:action_dispatch_integration_test) { include CookieJarProxy }
