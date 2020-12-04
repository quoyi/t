# frozen_string_literal: true

Rack::Attack.cache.store = Rails.cache

### Throttle Spammy Clients ###
Rack::Attack.throttle('req/ip', limit: ENV['ATTACK_LIMIT'].to_i, period: ENV['ATTACK_PERIOD'].to_i.minutes) do |req|
  req.ip
end

# IP blacklist
Rack::Attack.blocklist('blacklist/ip') do |req|
  ENV['ATTACK_BLOCK_IP']&.include?(req.ip)
end

# allow localhost
# Rack::Attack.safelist("allow from localhost") do |req|
#   req.ip == "127.0.0.1" || req.ip == "::1"
# end

### Custom Throttle Response ###
Rack::Attack.throttled_response = lambda do |_env|
  [503, {}, ENV['ATTACK_MESSAGE']]
end

ActiveSupport::Notifications.subscribe('track.rack_attack') do |_name, _start, _finish, request_id, payload|
  req = payload[:request]
  Rails.logger.info "  RackAttack: #{req.ip} #{request_id} blocked."
end
