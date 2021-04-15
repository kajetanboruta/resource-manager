require 'rails_helper'

RSpec.describe 'Tags_Export', type: :request do
  describe 'POST /tags_export/' do
    it 'schedules SendExportedTagsWorker in 3 minutes with given email' do
      params = {
        data: {
          attributes: {
            email: 'test@test.com'
          }
        }
      }.stringify_keys.to_json
      allow(SendExportedTagsWorker).to receive(:perform_at)

      travel 1.day do
        post_api('/api/v1/tags_export', params)

        expect(response).to have_http_status(:success)  
        expect(SendExportedTagsWorker).to have_received(:perform_at).with(3.minutes.from_now, email: 'test@test.com')
      end
    end
  end

  def post_api(path, params)
    post path, params: params, headers: headers
  end

  def headers
    { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }
  end
end
