# frozen_string_literal: true

Rails.autoloaders.each do |autoloader|
  autoloader.inflector.inflect(
    "retromeet" => "RetroMeet"
  )
end
