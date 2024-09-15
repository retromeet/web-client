# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    authentication_token = RetroMeetClient.login(login: params.dig(:sessions, :email),
                                                 password: params.dig(:sessions, :password))

    cookies[:Authentication] = authentication_token
    redirect_to :root
  rescue RetroMeetClient::BadPasswordError
    flash.now[:error] = I18n.t(".bad_password")
    render "new", status: :unauthorized
  rescue RetroMeetClient::BadLoginError
    flash.now[:error] = I18n.t(".bad_login")
    render "new", status: :unauthorized
  end
end
