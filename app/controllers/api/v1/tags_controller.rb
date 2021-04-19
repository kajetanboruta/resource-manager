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

      def show(id)
        json = {
          data: TagSerializer.new(Tag.where(id: id)).to_hash
        }
      end

      def create
        binding.pry
        v = tag_params
        form = TagForm.new(v[:attributes][:name], v[:relationships][:id])
      end

      private

      def tag_params
        JSON.parse(params)['data'].each_with_object({}) do |(item, value), hash|
          hash[item] = value
        end
      end
    end
  end
end
