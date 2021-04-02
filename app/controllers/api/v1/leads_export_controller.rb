module Api
  module V1
    class LeadsExportController < ApplicationController
      include ActionView::Rendering
      include ActionController::MimeResponds

      def create
        respond_to do |format|
          format.xlsx { render :xlsx, template: 'api/v1/leads_export/leads' }
        end
      end

      private

      def render_to_body(options)
        _render_to_body_with_renderer(options) || super
      end
    end
  end
end