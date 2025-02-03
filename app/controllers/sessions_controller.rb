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
      authorization_token = retro_meet_client.create_account(login: params[:email],
                                                             password: params[:password],
                                                             birth_date: @birth_date)
      flash[:success] = t(".account_created")
      start_new_session_for authorization_token
      redirect_to after_authentication_url
    else
      flash.now[:error] = t(".passwords_do_not_match")
      render "new_account", status: :bad_request
    end
  rescue RetroMeet::Core::TooYoungError
    flash.now[:error] = t(".birth_date_is_under_age")
    render "new_account", status: :bad_request
  rescue Date::Error
    flash.now[:error] = t(".date_invalid")
    render "new_account", status: :unprocessable_content
  rescue RetroMeet::Core::BadLoginError
    flash.now[:error] = t(".login_must_be_email")
    render "new_account", status: :unprocessable_content
  rescue RetroMeet::Core::BadPasswordError
    flash.now[:error] = t(".password_invalid")
    render "new_account", status: :unprocessable_content
  rescue RetroMeet::Core::LoginAlreadyTakenError
    flash.now[:error] = t(".login_is_already_in_use")
    render "new_account", status: :unprocessable_content
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
