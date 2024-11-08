# frozen_string_literal: true

# This class keeps the current session that's used for authentication
class Current < ActiveSupport::CurrentAttributes
  attribute :session
end
