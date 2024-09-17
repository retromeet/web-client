# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    redirect_to :root unless basic_profile_info.nil?
  end

  def create
    authorization_token = RetroMeetClient.login(login: params.dig(:sessions, :email),
                                                password: params.dig(:sessions, :password))

    cookies[:Authorization] = authorization_token
    redirect_to :root
  rescue RetroMeetClient::BadPasswordError
    flash.now[:error] = t(".bad_password")
    render "new", status: :unauthorized
  rescue RetroMeetClient::BadLoginError
    flash.now[:error] = t(".bad_login")
    render "new", status: :unauthorized
  end

  def destroy
    cookies.delete(:Authorization)
    redirect_to :root
  end
end
