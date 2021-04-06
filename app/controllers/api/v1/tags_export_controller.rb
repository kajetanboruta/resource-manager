module Api
  module V1
    class TagsExportController < ApplicationController
      include ActionView::Rendering
      include ActionController::MimeResponds

      def create
        render :xlsx, template: 'api/v1/tags_export/tags.xlsx.axlsx', locals: { tags: Tag.all }
      end

      private

      def render_to_body(options)
        _render_to_body_with_renderer(options) || super
      end
    end
  end
end
