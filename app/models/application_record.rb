# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :todays, -> { where(created_at: Time.zone.today.beginning_of_day..Time.zone.today.end_of_day) }

  def self.strftime
    Time.current.strftime('%Y%m%d%H%M%S')
  end
end
