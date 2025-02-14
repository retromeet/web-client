# frozen_string_literal: true

class SessionsController < ApplicationController
  layout "no_columns"
  allow_unauthenticated_access only: %i[new create new_account create_account]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    redirect_to :root if Current.session
    redirect_to retro_meet_client.authorize_url(state: form_authenticity_token)
  end

  def create
    flash[:success] = t(".logged_in")
    start_new_session_for request.env["omniauth.auth"]["credentials"]
    redirect_to after_authentication_url
  end

  def destroy
    terminate_session
    redirect_to root_path
  end
end
