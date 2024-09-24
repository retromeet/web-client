# frozen_string_literal: true

BasicProfileInfo = Data.define(:display_name, :created_at) do
  def initialize(display_name:, created_at:)
    created_at = DateTime.parse(created_at) if created_at.is_a?(String)
    super
  end
end
