# frozen_string_literal: true

# Enable paper_trail
PaperTrail.config.enabled = true

# Trigger
PaperTrail.config.has_paper_trail_defaults = {
  on: %i[create update destroy]
}

# Limit: 4 versions per record (3 most recent, plus a `create` event)
PaperTrail.config.version_limit = 3

# Saving More Information About Versions
# PaperTrail.request.whodunnit = proc do
#   caller.find { |c| c.starts_with? Rails.root.to_s }
# end
