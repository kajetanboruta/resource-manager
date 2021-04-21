class TagsJsonSerializer
  include Rails.application.routes.url_helpers

  def initialize(tags)
    @tags = tags
  end

  def to_json(*_args)
    tags_hash = tags.map do |tag|
      {
        type: 'tags',
        id: tag.id,
        links: { self: api_v1_tag_url(tag) },
        attributes: { name: tag.name },
        relationships: {
          'tag-category': {
            data: {
              type: 'tag-categories',
              id: tag.tag_category_id,
              attributes: {
                name: tag.tag_category.name
              }
            }
          }
        }
      }
    end
    {
      data: tags_hash
    }.to_json
  end

  alias dump to_json

  private

  attr_reader :tags
end
