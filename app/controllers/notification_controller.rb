# frozen_string_literal: true

class NotificationController < ApplicationController
  def index
    payload = params[:payload]
    payload = Base64.urlsafe_decode64(payload)
    payload = JSON.parse(payload, symbolize_names: true)
    case payload[:type]
    when "message"
      redirect_to conversation_messages_path(conversation_id: payload[:conversation_id]), status: :see_other
    when "report"
      redirect_to view_profile(id: payload[:profile_id]), status: :see_other
    else
      redirect_to :root, status: :see_other
    end
  end
end
