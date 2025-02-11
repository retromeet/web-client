# frozen_string_literal: true

module RetroMeet
  # This module contains functions to build the retromeet web version to be used around programatically
  # Should be modified when releasing to indicate the proper versions
  module Url
    class << self
      # @return [String]
      def to_s
        @to_s ||= "http#{Rails.configuration.x.use_https ? "s" : ""}://#{Rails.configuration.x.retromeet_web_host}/"
      end
    end
  end
end
