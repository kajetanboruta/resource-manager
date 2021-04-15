require 'rails_helper'

RSpec.describe ContactForm do
  context 'when correct data is provided' do
    it 'sends mail to predefined recipient' do
      mailer = double(:contact_form_mailer)
      allow(ContactFormMailer).to receive(:send_contact) { mailer }
      allow(mailer).to receive(:deliver_now)

      form = ContactForm.new(sender: 'mail@to.com', subject: 'subject_test', body: 'body_test')

      expect(form.save).not_to eq(false)
      expect(ContactFormMailer).to have_received(:send_contact).with(sender: 'mail@to.com', subject: 'subject_test', body: 'body_test')
      expect(mailer).to have_received(:deliver_now)
    end
  end
end
