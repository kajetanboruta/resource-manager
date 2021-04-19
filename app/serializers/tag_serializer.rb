class TagSerializer
  def initialize(tag)
    @tag = tag
  end

  def to_hash
    {
      type: 'tags',
      links: { self: Rails.application.routes.url_helpers.api_v1_tag_url(tag) },
      attributes: { name: tag.name }
    }
  end

  private

  attr_reader :tag
end
