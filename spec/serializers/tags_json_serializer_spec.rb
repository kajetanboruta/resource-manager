# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TagsJsonSerializer do
  describe '#to_json' do
    it 'returns serialized tags as JSON' do
      tag_category = create(:tag_category, name: 'programming language')
      tag1 = create(:tag, name: 'ruby', tag_category: tag_category)
      tag2 = create(:tag, name: 'js', tag_category: tag_category)

      json = TagsJsonSerializer.new(Tag.all).dump

      expect(json).to match(
        {
          data: [
            {
              type: 'tags',
              id: tag1.id,
              links: { self: "http://www.example.com/api/v1/tags/#{tag1.id}" },
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
            },
            {
              type: 'tags',
              id: tag2.id,
              links: { self: "http://www.example.com/api/v1/tags/#{tag2.id}" },
              attributes: { name: 'js' },
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
            }]
        }.to_json
      )
    end
  end
end
