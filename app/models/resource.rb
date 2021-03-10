class Resource < ApplicationRecord
    has_many :tag_assignments, as: :taggable
    has_many :tags, through: :tag_assignments
    has_one :resource_type
end
