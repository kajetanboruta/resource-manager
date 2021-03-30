class Tag < ApplicationRecord
  belongs_to :tag_category, optional: true
  has_many :tag_assignments
  validates :name, presence: true
  validates :tag_category, on: :create, presence: true
end
