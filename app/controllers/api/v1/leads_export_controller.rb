module Api
  module V1
    class LeadsExportController < ApplicationController
      include ActionView::Rendering
      include ActionController::MimeResponds

      def create
        render :xlsx, template: 'api/v1/leads_export/leads.xlsx', locals: { leads: Lead.all }
      end

      private

      def render_to_body(options)
        _render_to_body_with_renderer(options) || super
      end
    end
  end
end