module Api
  module V1
    class ContactsFormController < ApplicationController
      def create
        form = ContactForm.new(email: params['data']['attributes']['email'], subject: params['data']['attributes']['subject'], body: params['data']['attributes']['body'])
        form.save
      end
    end
  end
end