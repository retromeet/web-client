#!/usr/bin/env falcon-host
# frozen_string_literal: true

require "falcon/environment/rack"
require "falcon/environment/supervisor"

hostname = File.basename(__dir__)
service hostname do
  include Falcon::Environment::Rack

  # Insert an in-memory cache in front of the application (using async-http-cache).
  cache true
end

service "supervisor" do
  include Falcon::Environment::Supervisor
end
