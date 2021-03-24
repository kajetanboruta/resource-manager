require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  describe 'GET api/v1/tags' do
    it 'returns list of all tags' do
      tag_category1 = create(:tag_category, name: 'programming language')
      tag1 = create(:tag, name: 'Tag 1', tag_category_id: tag_category1)
      tag2 = create(:tag, name: 'Tag 2', tag_category_id: tag_category1)
      get '/api/v1/tags'

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      tags = json['data']

      expect(tags[0]['type']).to eq 'tags'
      expect(tags[0]['links']['self']).to eq "http://www.example.com/api/v1/tags/#{tag1.id}"
      expect(tags[0]['attributes']['name']).to eq 'Tag 1'
      expect(tags[1]['type']).to eq 'tags'
      expect(tags[1]['links']['self']).to eq "http://www.example.com/api/v1/tags/#{tag2.id}"
      expect(tags[1]['attributes']['name']).to eq 'Tag 2'
      expect(tags.count).to eq 2
    end
  end

  describe 'GET /tags/:id' do
    it 'returns tag by id' do
      tag1 = create(:tag, name: 'Tag 1')

      get "/api/v1/tags/#{tag1.id}"

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json['data']['id'].to_i).to eq tag1.id
    end
  
    context 'when no tag_id matches given id' do
      it 'returns error' do
        get '/api/v1/tags/1'

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /tags' do
    it 'creates new tag' do
      headers = { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }
      tag_category1 = create(:tag_category, name: "programming language")
      hash = {
        data: {
          type: 'tags',
          attributes: {
            name: 'ruby'
          },
          relationships: {
            tag_category: {
              data: {
                type: 'tag_category',
                id: tag_category1.id
              }
            }
          }
        }
      }.stringify_keys.to_json

      post '/api/v1/tags', params: hash, headers: headers
      binding.pry

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['name']).to eq('ruby')
    end
  
    context 'when no tag_category selected' do
      it 'returns error' do
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
            name: 'ruby_new',
          }
        }
      }.stringify_keys.to_json

      put "/api/v1/tags/#{tag1.id}", params: hash, headers: headers

      json = JSON.parse(response.body)
      expect(json['data']['attributes']['name']).to eq('ruby_new')
    end
    
    context 'when no tag_id matches given id' do
      it 'returns error' do
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
      end
    end
    
    context 'when no tag_category selected' do
      it 'returns error' do
      end
    end
  end

  describe 'DELETE /tags/:id' do
    it 'removes tag by id' do
      tag1 = create(:tag, name: 'ruby')

      delete "/api/v1/tags/#{tag1.id}"

      expect(response).to have_http_status(:success)
    end
  
    context 'when no id matches given id' do
      it 'returns error' do
        delete '/api/v1/tags/1'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
