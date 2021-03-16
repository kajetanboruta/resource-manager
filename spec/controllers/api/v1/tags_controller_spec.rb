require 'rails_helper'

RSpec.describe "Api::V1::TagsController", type: :request do
    describe "GET api/v1/tags" do
        it "returns list of all tags" do
            create(:tag, name: 'Tag 1')
            create(:tag, name: 'Tag 2')
            create(:tag, name: 'Tag 3')
            
            get '/api/v1/tags'
           
            expect(response).to have_http_status(200)  
            
            json = JSON.parse(response.body) 
            
            expect(json['data'].first['attributes']['name']).to eq 'Tag 1'
        end
    end    
    describe "GET /tags/:id" do
        it "returns tag by id" do
            tag1 = create(:tag, name: 'Tag 1')
            
            get 'api/v1/tags'
        
            expect(response).to have_http_status(200)

            json = JSON.parse(response.body)

            expect(json['data'].first['attributes']['id']).to eq tag1.id
        end
        context "when no tag_id matches given id" do
            it 'returns error' do
                
            end
        end
    end
    describe "POST /tags" do
        it "creates new tag" do

            post 'api/v1/tags', params: { :tag => 'ruby'}

            expect(JSON.parse(response.body)['tag']).to eq('ruby')
        end
        context 'when no tag_category selected' do
            it 'returns error' do
                
            end
        end
    end
    describe "PUT /tags/:id" do
        it "updates tag by id" do
            
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
