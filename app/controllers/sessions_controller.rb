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

  def new_account; end

  def create_account
    @email = params[:email]

    if params[:password] == params[:password_confirmation]
      authorization_token = RetroMeetClient.create_account(login: params[:email], password: params[:password])
      cookies[:Authorization] = authorization_token
      redirect_to :root
    else
      flash.now[:error] = t(".passwords_do_not_match")
      render "new_account", status: :bad_request
    end
  rescue RetroMeetClient::LoginAlreadyTakenError
    flash.now[:error] = t(".login_is_already_in_use")
    render "new_account", status: :unprocessable_content
  end

  def destroy
    retro_meet_client.sign_out
    cookies.delete(:Authorization)
    redirect_to :root
  end
end
