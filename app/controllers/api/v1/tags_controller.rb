module Api
  module V1
    class TagsController < ApplicationController
      rescue_from ActiveRecord::RecordNotFound do |_exception|
        render json: {
          errors: [
            {
              status: '404',
              detail: "The record identified by #{params[:id]} could not be found."
            }
          ]
        }, status: 404
      end

      def index
        tags = Tag.where(params.to_unsafe_hash[:filter]).order(params[:sort]).paginate(page_params)
        render json: TagsJsonSerializer.new(tags)
      end

      def show
        render json: TagJsonSerializer.new(tag)
      end

      def create
        form = TagForm.new(Tag.new, tag_params)

        if form.save
          render json: TagJsonSerializer.new(form.send(:resource))
        else
          render json: ErrorSerializer.new(form).serialize, status: 422
        end
      end

      def update
        form = TagForm.new(tag, tag_params)

        if form.save
          render json: TagJsonSerializer.new(form.send(:resource))
        else
          render json: ErrorSerializer.new(form).serialize, status: 422
        end
      end

      def destroy
        render json: TagJsonSerializer.new(tag.destroy)
      end

      private

      def tag_params
        unsafe_params = params.to_unsafe_hash

        return unsafe_params['data']['attributes'] if unsafe_params['data']['relationships'].blank?

        unsafe_params['data']['relationships'].each_with_object(unsafe_params['data']['attributes']) do |(key, value), attributes|
          attributes["#{key.underscore}_id"] = value['data']['id']
        end
      end

      def page_params
        return { page: 1 } if params[:page].blank?

        {
          page: params[:page][:number],
          per_page: params[:page][:size]
        }
      end

      def tag
        @tag ||= Tag.find(params[:id])
      end
    end
  end
end
