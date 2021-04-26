require 'rails_helper'

RSpec.describe TagFilterQuery do
  context 'filters tags' do
    it 'by name parameter' do
      tag_category = create(:tag_category, name: 'backend')
      tag_category2 = create(:tag_category, name: 'frontend')
      create(:tag, name: 'ruby', tag_category: tag_category)
      create(:tag, name: 'ruby', tag_category: tag_category2)
      create(:tag, name: 'c++')

      tags = TagFilterQuery.call(name: 'r')

      expect(tags.count).to eq(2)
      expect(tags[0].name).to eq('ruby')
      expect(tags[1].name).to eq('ruby')
    end

    it 'by tag_category_id parameter' do
      tag_category = create(:tag_category, name: 'backend')
      create(:tag, name: 'ruby', tag_category: tag_category)
      create(:tag, name: 'c++')
      create(:tag, name: 'js')

      tags = TagFilterQuery.call(tag_category_id: tag_category.id)

      expect(tags.count).to eq(1)
      expect(tags[0].tag_category_id).to eq(tag_category.id)
    end

    it 'by name and tag_category_id parameter' do
      tag_category = create(:tag_category, name: 'backend')
      tag_category2 = create(:tag_category, name: 'games')
      create(:tag, name: 'ruby', tag_category: tag_category)
      create(:tag, name: 'c++', tag_category: tag_category)
      create(:tag, name: 'ruby', tag_category: tag_category2)

      tags = TagFilterQuery.call(name: 'ruby', tag_category_id: tag_category.id)

      expect(tags.count).to eq(1)
      expect(tags[0].name).to eq('ruby')
    end
  end

  context 'when no parameter is passed' do
    it 'returns whole collection' do
      tag_category = create(:tag_category, name: 'backend')
      tag_category2 = create(:tag_category, name: 'games')
      create(:tag, name: 'ruby', tag_category: tag_category)
      create(:tag, name: 'c++', tag_category: tag_category)
      create(:tag, name: 'ruby', tag_category: tag_category2)

      tags = TagFilterQuery.call

      expect(tags.count).to eq(3)
    end
  end

  it 'filters tags by passed params' do
    tag_category = create(:tag_category, name: 'backend')
    create(:tag, name: 'ruby', tag_category: tag_category)
    create(:tag, name: 'c++', tag_category: tag_category)
    create(:tag, name: 'js', tag_category: tag_category)

    tags = TagFilterQuery.call(name: 'ruby', tag_category: tag_category)

    expect(tags.count).to eq(1)
    expect(tags[0].name).to eq('ruby')
  end

  context 'when unwanted parameter is passed to query' do
    it 'returns tags filtered by known parameters' do
      tag_category = create(:tag_category, name: 'backend')
      tag_category2 = create(:tag_category, name: 'api')
      create(:tag, name: 'ruby', tag_category: tag_category)
      create(:tag, name: 'c++', tag_category: tag_category)
      create(:tag, name: 'rails', tag_category: tag_category2)

      tags = TagFilterQuery.call(name: 'ub', tag_category_id: tag_category.id, unwanted_param: 'unwanted value')

      expect(tags.count).to eq(1)
      expect(tags[0].name).to eq('ruby')
    end
  end
end
