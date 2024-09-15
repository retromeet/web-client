# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    RetroMeetClient.login(params.dig(:session, :email), params.dig(:session, :password))
  end
end
