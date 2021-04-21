class TagForm < Patterns::Form
  attribute :name, String
  attribute :tag_category_id, Integer

  validates :name, :tag_category_id, presence: { message: "can't be blank" }

  private

  def persist
    binding.pry
    resource.update(attributes)
  end
end
