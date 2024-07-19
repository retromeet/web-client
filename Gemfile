# frozen_string_literal: true

source "https://rubygems.org"

ruby file: ".ruby-version"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.4"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use the Falcon web server [https://socketry.github.io/falcon/guides/rails-integration/index.html]
gem "falcon"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows]

  gem "rubocop", require: false # A static code analyzer and formatter
  gem "rubocop-performance", require: false # A rubocop extension with performance suggestions
  gem "rubocop-rake", require: false # A rubocop extension for Rakefiles
  gem "rubocop-sequel", require: false # A rubocop extension for Sequel
  gem "rubocop-yard", require: false # A rubocop extension for yard documentation
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
