# Pin npm packages by running ./bin/importmap

pin "application"
pin "bulma"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "choices.js" # @11.0.2
pin "stimulus-use" # @0.52.3
