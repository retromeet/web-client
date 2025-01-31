# frozen_string_literal: true

module RetroMeet
  module Core
    # Reports representation
    class Reports < Representation
      # @param target_profile_id [String] a uuid of the profile to be reported
      # @param type [String] one of the accepted report types.
      #   Refer to retromeet-core documentation for a up-to-date list, or to the +reports.types+ keys in the I18n file
      # @param comment [String,nil] Any comments the reporter has about this report. Can be empty
      # @param message_ids [Array<Integer>,nil] An array of message_ids or nil if no message ids are included in the report
      # @return [void]
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
