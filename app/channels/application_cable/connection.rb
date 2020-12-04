# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_or_guest_user

    def connect
      self.current_or_guest_user = find_verified_user
      logger.add_tags 'ActionCable', current_or_guest_user.name
    end

    private

    def find_verified_user
      # devise 用户
      env['warden'].user || reject_unauthorized_connection
    end
  end
end
