# frozen_string_literal: true

module CodeConcern
  extend ActiveSupport::Concern

  included do
    attribute :code, :string, default: -> { strftime + (todays.count + 1).to_s.rjust(4, '0') }

    validates :code, uniqueness: true
  end
end
