# frozen_string_literal: true

module RetroMeet
  module Core
    # Reports representation
    class Reports < Representation
      def create(target_profile_id:, type:, comment: nil, message_ids: nil)
        body = {
          target_profile_id:,
          type:,
          comment:,
          message_ids:
        }
        Reports.post(@resource, body)
      end
    end
  end
end
