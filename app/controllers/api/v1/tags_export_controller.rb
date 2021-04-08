module Api
  module V1
    class TagsExportController < ApplicationController
      def create
        SendExportedTagsWorker.perform_at(3.minutes.from_now, params['data']['attributes']['email'])
      end
    end
  end
end
