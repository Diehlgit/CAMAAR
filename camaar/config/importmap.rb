# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "controllers", to: "controllers.js"
pin "nested-forms/addFields", to: "nested-forms/addFields.js"
pin "nested-forms/removeFields", to: "nested-forms/removeFields.js"
