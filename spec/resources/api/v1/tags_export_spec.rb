require 'rails_helper'

RSpec.describe 'Tags_Export', type: :request do
  describe 'POST /tags_export/' do
    it 'sends email with exported xlsx file' do
      params = {
        data: {
          attributes: {
            email: 'test@test.com'
          }
        }
      }.stringify_keys.to_json
      
      post_api('/api/v1/tags_export', params)
      expect(response).to have_http_status(:success)
      json = JSON.parse(params)
      expect(json['data']['attributes']['email']).to eq('test@test.com')
    end
  end

  def post_api(path, params)
    post path, params: params, headers: headers
  end

  def headers
    { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }
  end
end
