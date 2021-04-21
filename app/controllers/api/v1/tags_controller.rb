module Api
  module V1
    class TagsController < ApplicationController
      def index
        binding.pry
        tags = Tag.paginate(page: params[:page][:number], per_page: params[:page][:size])

        render json: TagsJsonSerializer.new(tags)
      end

      def show
        tag = Tag.find(params[:id])

        render json: TagJsonSerializer.new(tag)
      end

      def create
        form = TagForm.new(Tag.new, tag_params)
        if form.save
          render json: { data: TagSerializer.new(form.send(:resource)) }
        else
          render json: ErrorSerializer.new(form).serialize, status: 422
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
