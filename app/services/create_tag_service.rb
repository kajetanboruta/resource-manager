class CreateTagService < Patterns::Service
  def initialize
    @name = name
    @tag_category_id = tag_category_id
  end

  def call
    Tag.create(name: name, tag_category_id: tag_category_id)
  end

  private

  attr_reader :name, :tag_category_id
end
