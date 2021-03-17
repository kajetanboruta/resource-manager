require 'rails_helper'

RSpec.describe 'Resources', type: :request do
  describe 'GET /resources' do
    it 'returns list of all resources' do
      create(:resource, name: 'resource 1')
      create(:resource, name: 'resource 2')
      create(:resource, name: 'resource 3')

      get '/api/v1/resources'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json['data'].first['attributes']['name']).to eq 'resource 1'
      expect(json['data'].count).to eq Resource.count
    end
  end
  describe 'GET /resources/:id' do
    it 'returns resource by id' do
      resource1 = create(:resource, name: 'resource 1')

      get "/api/v1/resources/#{resource1.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json['data']['attributes']['name']).to eq 'resource 1'
    end
    context 'when no resource_id matches given id' do
      it 'returns error' do
        get '/api/v1/resources/1'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
  describe 'POST /resources' do
    it 'creates new resource' do
      hash = {
        data: {
          type: 'resources',
          attributes: {
            name: 'article'
          }
        }
      }.stringify_keys.to_json
      headers = { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }

      post '/api/v1/resources', params: hash, headers: headers
      json = JSON.parse(response.body)

      expect(response.content_type).to eq('application/vnd.api+json')
      expect(response).to have_http_status(:created)
      expect(json['data']['attributes']['name']).to eq 'article'
    end
  end
  describe 'PUT /resources/:id' do
    it 'updates resource by id' do
      resource = create(:resource, name: 'new resource')
      headers = { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }
      hash = {
        data: {
          type: 'resources',
          id: resource.id,
          attributes: {
            name: 'updated resource'
          }
        }
      }.stringify_keys.to_json

      put "/api/v1/resources/#{resource.id}", params: hash, headers: headers
      json = JSON.parse(response.body)
      expect(json['data']['attributes']['name']).to eq 'updated resource'
    end
    context 'when no resource_id matches given id' do
      it 'returns error' do
        headers = { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }
        hash = {
          data: {
            type: 'resources',
            id: '1',
            attributes: {
              name: 'new article'
            }
          }
        }.stringify_keys.to_json

        put '/api/v1/resources/1', params: hash, headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
  describe 'DELETE /resources/:id' do
    it 'removes resource by id' do
      resource_to_remove = create(:resource, name: 'resource 1')

      delete "/api/v1/resources/#{resource_to_remove.id}"

      expect(response).to have_http_status(204)
    end
    context 'when no id matches given id' do
      it 'returns error' do
        delete '/api/v1/resources/1'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
