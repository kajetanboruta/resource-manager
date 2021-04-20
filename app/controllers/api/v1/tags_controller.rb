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

      def create
        form = TagForm.new(Tag.new, tag_params)
        if form.save
          render json: { data: TagSerializer.new(form.send(:resource))}
        else
        end

      end

      private

      def tag_params
        unsafe_params = params.to_unsafe_hash
        unsafe_params['data']['relationships'].each_with_object(unsafe_params['data']['attributes']) do |(key, value), attributes|
          attributes["#{key.underscore}_id"] = value['data']['id']
        end
      end
    end
  end
end
