require 'rails_helper'

RSpec.describe "Tags", type: :request do
    describe "GET api/v1/tags" do
        it "returns list of all tags" do
            tag1 = create(:tag, name: 'Tag 1')
            tag2 = create(:tag, name: 'Tag 2')
            tag3 = create(:tag, name: 'Tag 3')
            tag4 = create(:tag, name: 'Tag 4')
            
            get '/api/v1/tags'
           
            expect(response).to have_http_status(200)  
            
            json = JSON.parse(response.body) 

            expect(json['data'].first['attributes']['name']).to eq "Tag 1"
            expect(json['data'].count).to eq Tag.count
        end
    end    
    describe "GET /tags/:id" do
        it "returns tag by id" do
            tag1 = create(:tag, name: 'Tag 1')
            
            get '/api/v1/tags'
        
            expect(response).to have_http_status(200)

            json = JSON.parse(response.body)
            expect(json['data'].first['id'].to_i).to eq tag1.id
        end
        context "when no tag_id matches given id" do
            it 'returns error' do
                
            end
        end
    end
    describe "POST /tags" do
        it "creates new tag" do
            headers = { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }
            hash = {
                data: {
                    type: "tags",
                    attributes: {
                        name: "ruby"
                    }
                }
            }.stringify_keys.to_json
            
            post '/api/v1/tags', params: hash, headers: headers
            json = JSON.parse(response.body)
            
            expect(json['data']['attributes']['name']).to eq('ruby')
        end
        context 'when no tag_category selected' do
            it 'returns error' do
                
            end
        end
    end
    describe "PUT /tags/:id" do
        it "updates tag by id" do
            tag1 = create(:tag, name: 'ruby')
            headers = { 'ACCEPT' => 'application/vnd.api+json', 'CONTENT_TYPE' => 'application/vnd.api+json' }
            hash = {
                data: {
                    type: "tags",
                    id: tag1.id,
                    attributes: {
                        name: "ruby_new"
                    }
                }
            }.stringify_keys.to_json
            
            put "/api/v1/tags/#{tag1.id}", params: hash, headers: headers
            
            json = JSON.parse(response.body)
            binding.pry
            expect(json['data']['attributes']['name']).to eq('ruby_new')
        end
        context 'when no tag_id matches given id' do
            it 'returns error' do
                
            end
        end
        context 'when no tag_category selected' do
            it 'returns error' do
                
            end
        end
    end
    describe "DELETE /tags/:id" do
        it "removes tag by id" do
            
        end
        context 'when no id matches given id' do
            it 'returns error' do
                
            end
        end
    end
end
