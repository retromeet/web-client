# frozen_string_literal: true

Conversation = Data.define(:id,
                           :other_profile,
                           :created_at,
                           :last_seen_at,
                           :new_messages_preview) do
  def initialize(id:, created_at:, last_seen_at: nil, other_profile: nil, new_messages_preview: nil)
    other_profile = OtherProfileInfo.new(**other_profile.slice(*OtherProfileInfo.members)) if other_profile
    super
  end
end
