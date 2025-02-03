# frozen_string_literal: true

require_relative "retromeet_core" # needs to be loaded before the strategy
require_relative "../../app/objects/retromeet/omniauth_strategy"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider OmniAuth::Strategies::RetroMeetCore
end
