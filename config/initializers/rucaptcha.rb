# frozen_string_literal: true

RuCaptcha.config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] }

Recaptcha.configure do |config|
  # config.site_key       = ENV['RECAPTCHA_KEY']
  # config.secret_key     = ENV['RECAPTCHA_SECRET']
  # config.api_server_url = 'https://recaptcha.net/recaptcha/api.js'
  # config.verify_url     = 'https://recaptcha.net/recaptcha/api/siteverify'
end
