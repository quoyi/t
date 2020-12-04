# frozen_string_literal: true

# override set protected_attributes
module PaperTrail
  class Version < ActiveRecord::Base
    include PaperTrail::VersionConcern

    # attr_accessible :item_type, :item_id, :event, :whodunnit, :object, :object_changes, :created_at
  end
end
