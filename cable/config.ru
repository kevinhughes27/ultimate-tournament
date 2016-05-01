# cable/config.ru

require ::File.expand_path('../../config/environment',  __FILE__)
Rails.application.eager_load!

require 'action_cable/process/logging'

ActionCable.server.config.allowed_request_origins = ["http://no-borders.lvh.me:3000"]
run ActionCable.server
