# frozen_string_literal: true

class SessionsController < ApplicationController
  layout "no_columns"
  allow_unauthenticated_access only: %i[new create new_account create_account]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    redirect_to :root if Current.session
  end

  def create
    authorization_token = RetroMeet::Client.login(login: params[:email],
                                                  password: params[:password],
                                                  user_ip: request.ip)
    # user_agent: request.user_agent,
    # ip_address: request.remote_ip)
    start_new_session_for authorization_token
    redirect_to after_authentication_url
  rescue RetroMeet::Client::BadPasswordError
    flash.now[:error] = t(".bad_password")
    render "new", status: :unauthorized
  rescue RetroMeet::Client::BadLoginError
    flash.now[:error] = t(".bad_login")
    render "new", status: :unauthorized
  end

  def new_account
    redirect_to :root if Current.session
  end

  def create_account
    @email = params[:email]

    @birth_date = Date.parse(params[:birth_date])
    if @birth_date.year >= Date.today.year - 16
      flash.now[:error] = t(".birth_date_is_under_age")
      render "new_account", status: :bad_request
    elsif params[:password] == params[:password_confirmation]
      authorization_token = RetroMeet::Client.create_account(login: params[:email],
                                                             password: params[:password],
                                                             birth_date: @birth_date,
                                                             user_ip: request.ip)
      start_new_session_for authorization_token
      redirect_to after_authentication_url
    else
      flash.now[:error] = t(".passwords_do_not_match")
      render "new_account", status: :bad_request
    end
  rescue RetroMeet::Client::TooYoungError
    flash.now[:error] = t(".birth_date_is_under_age")
    render "new_account", status: :bad_request
  rescue Date::Error
    flash.now[:error] = t(".date_invalid")
    render "new_account", status: :unprocessable_content
  rescue RetroMeet::Client::BadPasswordError
    flash.now[:error] = t(".password_invalid")
    render "new_account", status: :unprocessable_content
  rescue RetroMeet::Client::LoginAlreadyTakenError
    flash.now[:error] = t(".login_is_already_in_use")
    render "new_account", status: :unprocessable_content
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
