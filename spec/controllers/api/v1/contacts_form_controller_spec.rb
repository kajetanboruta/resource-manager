require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  describe 'POST api/v1/contact_form' do
    it 'sends mail with contact_form data' do
      params = {
        data: {
          type: 'contact_mail',
          attributes: {
            subject: 'subject_test',
            body: 'body_test',
            sender: 'test@sender.com'
          }
        }
      }.stringify_keys.to_json

      post_api('/api/v1/contacts_form', params)

      expect(response).to have_http_status(:success)
    end
  end

  def post_api(path, params)
    post path, params: params, headers: headers
  end

  def headers
    { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }
  end
end
