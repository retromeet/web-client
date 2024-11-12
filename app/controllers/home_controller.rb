# frozen_string_literal: true

class HomeController < ApplicationController
  layout "home", only: %i[index]
  layout "no_columns", except: %i[index]
  allow_unauthenticated_access
end
