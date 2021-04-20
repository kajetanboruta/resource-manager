module Api
  module V1
    class TagsController < ApplicationController
      def index
        json = {
          data: Tag.all.map do |tag|
            TagSerializer.new(tag).to_hash
          end
        }.to_json

        render json: json
      end

      def show
        tag = Tag.find(params[:id])
        json = {
          data:
            TagSerializer.new(tag).to_hash
        }.to_json

        render json: json
      end

      def create
        form = TagForm.new(Tag.new, tag_params)
        if form.save
          render json: { data: TagSerializer.new(form.send(:resource)) }
        else
          binding.pry
          json = {
            errors: form.errors.map do |error|
              binding.pry

              { status: '422', detail: error.full_message }
            end
          }
          # render json: { errors: [{ status: '422', detail: form.errors.first.full_message }] },
          #        status: 422
          render json: json, status: 422
        end
      end

      private

      def tag_params
        unsafe_params = params.to_unsafe_hash

        return unsafe_params['data']['attributes'] if unsafe_params['data']['relationships'].blank?

        unsafe_params['data']['relationships'].each_with_object(unsafe_params['data']['attributes']) do |(key, value), attributes|
          attributes["#{key.underscore}_id"] = value['data']['id']
        end
      end
    end
  end
end
