class Tag < ApplicationRecord
  belongs_to :tag_category
  has_many :tag_assignments
  validates :name, presence: true
end
