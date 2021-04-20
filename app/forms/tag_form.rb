class TagForm < Patterns::Form
  attribute :name, String
  attribute :tag_category_id, Integer

  validates :name, :tag_category_id, presence: true

  private

  def persist
    resource.update(attributes)
  end
end
