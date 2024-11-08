# frozen_string_literal: true

class HomeController < ApplicationController
  layout "home", only: %i[index]
  layout "no_columns", only: %i[terms]
  allow_unauthenticated_access

  def index; end

  def terms; end
end
