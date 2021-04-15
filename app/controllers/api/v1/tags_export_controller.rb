module Api
  module V1
    class TagsExportController < ApplicationController
      def create
        form = TagReportScheduleForm.new(email: params['data']['attributes']['email'])
        if form.save == false
          raise "Report was not send because attribute #{form.errors.first.attribute} was type of #{form.errors.first.type}"
        end
      end
    end
  end
end
