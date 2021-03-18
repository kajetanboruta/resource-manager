class Tag < ApplicationRecord
  has_many :tag_assignments
  validates :name, presence: true
end
