class TagForm < Patterns::Form
  attribute :name, String
  attribute :tag_category_id, Integer

  validates :name, :tag_category_id, presence: true

  private

  def persist
    create_tag
  end

  def create_tag
    CreateTagService.new(:name, :tag_category_id).call
  end
end
