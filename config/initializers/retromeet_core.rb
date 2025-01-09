# frozen_string_literal: true

Rails.application.configure do
  config.x.retromeet_core_host = ENV.fetch("RETROMEET_CORE_HOST", "http://localhost:3000/")
end
