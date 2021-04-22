class TagsJsonSerializer
  include Rails.application.routes.url_helpers

  def initialize(tags)
    @tags = tags
  end

  def to_json(*_args)
    {
      links: {
        self: api_v1_tags_url(page: { number: tags.current_page, size: tags.per_page }),
        first: api_v1_tags_url(page: { number: 1, size: tags.per_page }),
        prev: api_v1_tags_url(page: { number: tags.previous_page, size: tags.per_page }),
        next: api_v1_tags_url(page: { number: tags.next_page, size: tags.per_page }),
        last: api_v1_tags_url(page: { number: tags.total_pages, size: tags.per_page })
      },
      data: tags.map { |tag| JSON.parse(TagJsonSerializer.new(tag).to_json)['data'] }
    }.to_json
  end

  alias dump to_json

  private

  attr_reader :tags
end
