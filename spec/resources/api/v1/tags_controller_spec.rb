require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  describe 'GET api/v1/tags' do
    it 'returns list of all tags' do
      tag_ruby = create(:tag, name: 'Ruby')
      tag_js = create(:tag, name: 'JS')

      get '/api/v1/tags'

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      tags = json['data']
      tag1 = tags[0]
      expect(tag1['type']).to eq 'tags'
      expect(tag1['links']['self']).to eq "http://www.example.com/api/v1/tags/#{tag_ruby.id}"
      expect(tag1['attributes']['name']).to eq 'Ruby'
      tag2 = tags[1]
      expect(tag2['type']).to eq 'tags'
      expect(tag2['links']['self']).to eq "http://www.example.com/api/v1/tags/#{tag_js.id}"
      expect(tag2['attributes']['name']).to eq 'JS'
      expect(tags.count).to eq 2
    end

    it 'returns first page with 2 tags' do
      tag_ruby = create(:tag, name: 'Ruby')
      tag_js = create(:tag, name: 'JS')
      create(:tag, name: 'Java')
      create(:tag, name: 'C')

      get '/api/v1/tags', { params: { page: { size: 2 } } }

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      tags = json['data']
      tag1 = tags[0]
      expect(tag1['type']).to eq 'tags'
      expect(tag1['links']['self']).to eq "http://www.example.com/api/v1/tags/#{tag_ruby.id}"
      expect(tag1['attributes']['name']).to eq 'Ruby'
      tag2 = tags[1]
      expect(tag2['type']).to eq 'tags'
      expect(tag2['links']['self']).to eq "http://www.example.com/api/v1/tags/#{tag_js.id}"
      expect(tag2['attributes']['name']).to eq 'JS'
      expect(json['links']['next']).to eq 'http://www.example.com/api/v1/tags?page%5Bnumber%5D=2&page%5Bsize%5D=2'
    end

    it 'returns sorted tags by name' do
      create(:tag, name: 'ruby')
      create(:tag, name: 'js')
      create(:tag, name: 'java')
      create(:tag, name: 'c')

      get '/api/v1/tags', params: { sort: 'name' }

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      tags = json['data']
      expect(tags[0]['attributes']['name']).to eq 'c'
      expect(tags[1]['attributes']['name']).to eq 'java'
      expect(tags[2]['attributes']['name']).to eq 'js'
      expect(tags[3]['attributes']['name']).to eq 'ruby'
    end

    it 'returns filtered tags by tag_category' do
      tag_category1 = create(:tag_category, name: 'programming language')
      tag_category2 = create(:tag_category, name: 'backend')
      tag_ruby = create(:tag, name: 'ruby', tag_category_id: tag_category2.id)
      create(:tag, name: 'js', tag_category_id: tag_category1.id)
      tag_java = create(:tag, name: 'java', tag_category_id: tag_category2.id)
      tag_c = create(:tag, name: 'c', tag_category_id: tag_category2.id)

      get "/api/v1/tags?filter[tag-category]=#{tag_category2.id}"

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      tags = json['data']
      tag1 = tags[0]
      expect(tag1['type']).to eq 'tags'
      expect(tag1['links']['self']).to eq "http://www.example.com/api/v1/tags/#{tag_ruby.id}"
      expect(tag1['attributes']['name']).to eq 'ruby'
      tag2 = tags[1]
      expect(tag2['type']).to eq 'tags'
      expect(tag2['links']['self']).to eq "http://www.example.com/api/v1/tags/#{tag_java.id}"
      expect(tag2['attributes']['name']).to eq 'java'
      tag3 = tags[2]
      expect(tag3['type']).to eq 'tags'
      expect(tag3['links']['self']).to eq "http://www.example.com/api/v1/tags/#{tag_c.id}"
      expect(tag3['attributes']['name']).to eq 'c'
    end
  end

  describe 'GET /tags/:id' do
    it 'returns tag by id' do
      tag1 = create(:tag, name: 'Ruby')

      get "/api/v1/tags/#{tag1.id}"

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['data']['id'].to_i).to eq tag1.id
    end

    context 'when no tag_id matches given id' do
      it 'returns 404 http code, not found' do
        get '/api/v1/tags/1'

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        errors = json.fetch('errors')
        error1 = errors[0]
        expect(error1['status']).to eq('404')
        expect(error1['detail']).to eq('The record identified by 1 could not be found.')
      end
    end
  end

  describe 'POST /tags' do
    it 'creates new tag by given parameters and returns persisted object' do
      headers = { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }
      tag_category1 = create(:tag_category, name: 'programming language')
      hash = {
        data: {
          type: 'tags',
          attributes: {
            name: 'ruby'
          },
          relationships: {
            'tag-category': {
              data: {
                type: 'tag-categories',
                id: tag_category1.id
              }
            }
          }
        }
      }.stringify_keys.to_json

      post '/api/v1/tags', params: hash, headers: headers

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['data']['attributes']['name']).to eq('ruby')
    end

    context 'when tag-category parameter is not provided' do
      it 'returns 422 http code, unprocessable_entity' do
        headers = { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }
        hash = {
          data: {
            type: 'tags',
            attributes: {
              name: 'ruby'
            }
          }
        }.stringify_keys.to_json

        post '/api/v1/tags', params: hash, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        errors = json.fetch('errors')
        error1 = errors[0]
        expect(error1['status']).to eq('422')
        expect(error1['detail']).to eq("tag-category - can't be blank")
      end
    end
  end

  describe 'PUT /tags/:id' do
    it 'updates tag by id' do
      tag1 = create(:tag, name: 'ruby')
      headers = { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }
      hash = {
        data: {
          type: 'tags',
          id: tag1.id,
          attributes: {
            name: 'ruby_new'
          }
        }
      }.stringify_keys.to_json

      expect {
        put "/api/v1/tags/#{tag1.id}", params: hash, headers: headers }
        .to change { tag1.reload.name }.from('ruby').to('ruby_new')

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['data']['attributes']['name']).to eq('ruby_new')
    end

    it 'updates tag relationship' do
      tag_category1 = create(:tag_category, name: 'new version pack')
      tag1 = create(:tag, name: 'ruby', tag_category: tag_category1)
      headers = { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }
      hash = {
        data: {
          type: 'tags',
          id: tag1.id,
          attributes: {
            name: 'ruby_new'
          }
        },
        relationships: {
          'tag-category': {
            data: {
              type: 'tag_categories',
              id: tag_category1.id
            }
          }
        }
      }.stringify_keys.to_json

      put "/api/v1/tags/#{tag1.id}", params: hash, headers: headers

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json['data']['attributes']['tag-category-id']).to eq(tag_category1.id)
    end

    context 'when no tag_id matches given id' do
      it 'returns 404 http code, not found' do
        headers = { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }
        hash = {
          data: {
            type: 'tags',
            id: 1,
            attributes: {
              name: 'ruby_new'
            }
          }
        }.stringify_keys.to_json

        put '/api/v1/tags/1', params: hash, headers: headers

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        errors = json.fetch('errors')
        error1 = errors[0]
        expect(error1['status']).to eq('404')
        expect(error1['detail']).to eq('The record identified by 1 could not be found.')
      end
    end
  end

  describe 'DELETE /tags/:id' do
    context 'when no id matches given id' do
      it 'returns 404 http code, not_found' do
        delete '/api/v1/tags/1'

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        errors = json.fetch('errors')
        error1 = errors[0]
        expect(error1['status']).to eq('404')
        expect(error1['detail']).to eq('The record identified by 1 could not be found.')
      end
    end

    context 'when any tag.id matches provided id' do
      it 'removes tag by id' do
        tag1 = create(:tag, name: 'ruby')

        delete "/api/v1/tags/#{tag1.id}"

        expect(response).to have_http_status(:success)
      end
    end
  end
end
