class Tag < ApplicationRecord
  belongs_to :tag_category, optional: true
  has_many :tag_assignments
  validates :name, presence: true
end
