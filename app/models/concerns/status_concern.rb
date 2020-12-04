# frozen_string_literal: true

module StatusConcern
  extend ActiveSupport::Concern

  included do
    enum status: { enabled: 0, disabled: 1, deleted: 2 }
  end

  # scope :availables, -> { where.not(status: :deleted) }
end
