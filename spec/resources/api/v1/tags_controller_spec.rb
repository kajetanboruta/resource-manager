require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  describe 'GET api/v1/tags' do
    it 'returns list of all tags' do
      tag_category1 = create(:tag_category, name: 'programming language')
      tag1 = create(:tag, name: 'Ruby', tag_category_id: tag_category1.id)
      tag2 = create(:tag, name: 'JS', tag_category: tag_category1)

      get '/api/v1/tags'

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      tags = json['data']
      expect(tags[0]['type']).to eq 'tags'
      expect(tags[0]['links']['self']).to eq "http://www.example.com/api/v1/tags/#{tag1.id}"
      expect(tags[0]['attributes']['name']).to eq 'Ruby'
      expect(tags[1]['type']).to eq 'tags'
      expect(tags[1]['links']['self']).to eq "http://www.example.com/api/v1/tags/#{tag2.id}"
      expect(tags[1]['attributes']['name']).to eq 'JS'
      expect(tags.count).to eq 2
    end
  end

  describe 'GET /tags/:id' do
    it 'returns tag by id' do
      tag_category1 = create(:tag_category, name: 'programming language')
      tag1 = create(:tag, name: 'Ruby', tag_category: tag_category1)

      get "/api/v1/tags/#{tag1.id}"

      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json['data']['id'].to_i).to eq tag1.id
    end

    context 'when no tag_id matches given id' do
      it 'returns 404 http code, not found' do
        get '/api/v1/tags/1'

        json = JSON.parse(response.body)
        errors = json.fetch('errors')
        expect(response).to have_http_status(:not_found)
        expect(errors[0]['status']).to eq('404')
        expect(errors[0]['detail']).to eq('The record identified by 1 could not be found.')
      end
    end
  end

  describe 'POST /tags' do
    it 'creates new tag by given attributes and returns persisted object' do
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

    context 'when tag category parameters is not provided' do
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

        json = JSON.parse(response.body)
        errors = json.fetch('errors')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(errors[0]['status']).to eq('422')
        expect(errors[0]['detail']).to eq("tag-category - can't be blank")
      end
    end
  end

  describe 'PUT /tags/:id' do
    it 'updates tag by id' do
      tag_category_good = create(:tag_category, name: 'programming language')
      tag1 = create(:tag, name: 'ruby', tag_category: tag_category_good)
      headers = { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }
      hash = {
        data: {
          type: 'tags',
          id: tag1.id,
          attributes: {
            name: 'ruby_new'
          },
          relationships: {
            'tag-category': {
              data: {
                type: 'tag-categories',
                id: tag_category_good.id
              }
            }
          }
        }
      }.stringify_keys.to_json

      expect { put "/api/v1/tags/#{tag1.id}", params: hash, headers: headers }.to change {
                                                                                    tag1.reload.name
                                                                                  }.from('ruby').to('ruby_new')

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

    context 'when no tag_category is selected' do
      it 'returns error' do
      end
    end
  end

  describe 'DELETE /tags/:id' do
    it 'removes tag by id' do
      tag_category1 = create(:tag_category, name: 'programming language')
      tag1 = create(:tag, name: 'ruby', tag_category: tag_category1)

      delete "/api/v1/tags/#{tag1.id}"

      expect(response).to have_http_status(:success)
    end

    context 'when no id matches given id' do
      it 'returns 404 http code' do
        delete '/api/v1/tags/1'

        json = JSON.parse(response.body)
        errors = json.fetch('errors')
        expect(response).to have_http_status(:not_found)
        expect(errors[0]['status']).to eq('404')
        expect(errors[0]['detail']).to eq("The record identified by 1 could not be found.")
      end
    end
  end
end
