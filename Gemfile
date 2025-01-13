# frozen_string_literal: true

source "https://rubygems.org"

ruby file: ".ruby-version"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.1"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"

# Use the Falcon web server [https://socketry.github.io/falcon/guides/rails-integration/index.html]
gem "falcon"

gem "haml" # Allows to use haml template files instead of erb
gem "haml-rails", "~> 2.0"

gem "kramdown" # Allows for markdown in haml files, look more into this

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "async-http" # Used for making requests towards retromeet-core
gem "multipart-post" # Used for sending files over to retromeet-core

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Code formatting and hooks
  gem "lefthook", require: false # Used to make git hooks available between dev machines
  gem "pronto", "~> 0.11", require: false # pronto analyzes code on changed code only
  gem "pronto-rubocop", require: false # pronto-rubocop extends pronto for rubocop

  gem "rubocop", require: false # A static code analyzer and formatter
  gem "rubocop-capybara", require: false
  gem "rubocop-performance", require: false # A rubocop extension with performance suggestions
  gem "rubocop-rails", require: false # A rubocop extension with performance suggestions
  gem "rubocop-rake", require: false # A rubocop extension for Rakefiles
  gem "rubocop-yard", require: false # A rubocop extension for yard documentation
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"

  gem "mocha" # adds mocking capabilities
  gem "webmock" # Used for avoiding real requests in the test enviroment
end
