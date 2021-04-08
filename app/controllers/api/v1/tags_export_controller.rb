module Api
  module V1
    class TagsExportController < ApplicationController
      def create
        SendExportedTagsWorker.perform_in(5.minutes, params['data']['attributes']['email'])
      end
    end
  end
end
