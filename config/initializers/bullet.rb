# frozen_string_literal: true

require 'bullet'

Rails.application.configure do
  config.after_initialize do
    Bullet.enable        = true
    # Bullet.alert         = true
    Bullet.bullet_logger = true
    # Bullet.console       = true
    # Bullet.growl         = true
    # Bullet.rails_logger  = true
    Bullet.add_footer    = true
    Bullet.raise         = true # raise an error if n+1 query occurs
  end
end
