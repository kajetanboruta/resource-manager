module Api
  module V1
    class TagsController < ApplicationController
      def index
        json = TagsJsonSerializer.new(Tag.all).dump
        render json: json
      end

      def show
        tag = Tag.find(params[:id])
        json = TagJsonSerializer.new(tag).dump

        render json: json
      end

      def create
        form = TagForm.new(Tag.new, tag_params)
        if form.save
          render json: { data: TagSerializer.new(form.send(:resource)) }
        else
          json = ErrorSerializer.new(form).serialize.to_json
          # binding.pry
          # json = {
          #   errors: form.errors.map do |error|
          #     binding.pry

          #     { status: '422', detail: error.full_message }
          #   end
          # }
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
