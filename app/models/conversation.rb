# frozen_string_literal: true

Conversation = Data.define(:id,
                           :other_profile,
                           :created_at,
                           :last_seen_at,
                           :new_messages_preview) do
  def initialize(id:, other_profile:, created_at:, last_seen_at:, new_messages_preview:)
    other_profile = OtherProfileInfo.new(**other_profile.slice(*OtherProfileInfo.members))
    super
  end
end
