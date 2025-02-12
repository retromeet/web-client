# frozen_string_literal: true

namespace :oauth_client do
  desc "This command creates the OAuth2 client in the RetroMeet Core. RetroMeet Core needs to be running or this task will fail.
    After creating, this command will output the ID and the Secret. These *need* to be saved as they cannot be recovered."
  task create: :environment do
    RetroMeet::Core.connect do |client|
      register_response = client.oauth2.register(Rails.application.routes.url_helpers.auth_callback_path)
      pastel = Pastel.new
      puts pastel.green("Successfully registered!")
      puts pastel.yellow("OAUTH_CLIENT_ID=#{register_response[:client_id]}")
      puts pastel.yellow("OAUTH_CLIENT_SECRET=#{register_response[:client_secret]}")
      puts pastel.yellow("OAUTH_REGISTRATION_ACCESS_TOKEN=#{register_response[:registration_access_token]}")
      puts pastel.green("Add those to your `.env.#{Rails.env}` file.")
    end
  end
end
