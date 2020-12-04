# frozen_string_literal: true

Rails.application.configure do
  # Enable lograge
  config.lograge.enabled = true

  # API-only model and inherit from ActionController::API
  # config.lograge.base_controller_class = 'ActionController::API'

  # Multiple base controller
  # config.lograge.base_controller_class = ['ActionController::API', 'ActionController::Base']

  # add custom data by `custom_options`(must return a hash)
  config.lograge.custom_options = lambda do |_event|
    # capture some specific timing values you are interested in
    # { name: 'value', timing: some_float.round(2), host: event.payload[:host] }
    { time: Time.zone.now }
  end

  # Keep original Rails logger
  # config.lograge.logger = ActiveSupport::Logger.new("#{Rails.root}/log/lograge_#{Rails.env}.log")
end
