require 'rails_helper'

RSpec.describe 'Leads', type: :request do
  describe 'GET /leads' do
    it 'returns list of all leads' do
      create(:lead, name: 'Lead 1')
      create(:lead, name: 'Lead 2')
      create(:lead, name: 'Lead 3')

      get '/api/v1/leads'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json['data'].first['attributes']['name']).to eq 'Lead 1'
      expect(json['data'].count).to eq Lead.count
    end
  end
  describe 'GET /leads/:id' do
    it 'returns lead by id' do
      lead1 = create(:lead, name: 'Lead 1')

      get "/api/v1/leads/#{lead1.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json['data']['attributes']['name']).to eq 'Lead 1'
    end
    context 'when no lead_id matches given id' do
      it 'returns error' do
        get '/api/v1/leads/1'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
  describe 'POST /leads' do
    it 'creates new lead' do
      hash = {
        data: {
          type: 'leads',
          attributes: {
            name: 'client'
          }
        }
      }.stringify_keys.to_json
      headers = { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }

      post '/api/v1/leads', params: hash, headers: headers
      json = JSON.parse(response.body)

      expect(response.content_type).to eq('application/vnd.api+json')
      expect(response).to have_http_status(:created)
      expect(json['data']['attributes']['name']).to eq 'client'
    end
  end
  describe 'PUT /leads/:id' do
    it 'updates lead by id' do
      lead = create(:lead, name: 'new lead')
      headers = { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }
      hash = {
        data: {
          type: 'leads',
          id: lead.id,
          attributes: {
            name: 'updated lead'
          }
        }
      }.stringify_keys.to_json

      put "/api/v1/leads/#{lead.id}", params: hash, headers: headers
      json = JSON.parse(response.body)
      expect(json['data']['attributes']['name']).to eq 'updated lead'
    end
    context 'when no lead_id matches given id' do
      it 'returns error' do
        headers = { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }
        hash = {
          data: {
            type: 'leads',
            id: '1',
            attributes: {
              name: 'newClient'
            }
          }
        }.stringify_keys.to_json

        put '/api/v1/leads/1', params: hash, headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
  describe 'DELETE /leads/:id' do
    it 'removes lead by id' do
      lead_to_remove = create(:lead, name: 'Lead 1')

      delete "/api/v1/leads/#{lead_to_remove.id}"

      expect(response).to have_http_status(204)
    end
    context 'when no id matches given id' do
      it 'returns error' do
        delete '/api/v1/leads/1'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
