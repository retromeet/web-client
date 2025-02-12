# frozen_string_literal: true

port = ENV.fetch("PORT", 3001)
host = ENV.fetch("LOCAL_DOMAIN") { "localhost:#{port}" }

https = Rails.env.production? || ENV["LOCAL_HTTPS"] == "true"

Rails.application.configure do
  config.x.use_https = https
  config.x.retromeet_web_host = host
end
