require 'rails_helper'

RSpec.describe TagJsonSerializer do
  describe '#to_json' do
    it 'returns serialized tag as JSON' do
      tag_category = create(:tag_category, name: 'programming language')
      tag = create(:tag, name: 'ruby', tag_category: tag_category)

      json = TagJsonSerializer.new(tag).dump

      expect(json).to match(
        {
          data: {
            type: 'tags',
            id: tag.id,
            links: { self: "http://www.example.com/api/v1/tags/#{tag.id}" },
            attributes: { name: 'ruby' },
            relationships: {
              'tag-category': {
                data: {
                  type: 'tag-categories',
                  id: tag_category.id,
                  attributes: {
                    name: 'programming language'
                  }
                }
              }
            }
          }
        }.to_json
      )
    end
  end
end
