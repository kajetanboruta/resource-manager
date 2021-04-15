require 'rails_helper'

RSpec.describe ContactFormMailer, type: :mailer do
  it 'renders the headers' do
    mail_contact = ContactFormMailer.send_contact(subject: ['test_subject'], body: ['test_body'], sender: ['test@sender.com'])

    expect(mail_contact.subject).to eq('test_subject')
    expect(mail_contact.from).to eq(['test@sender.com'])
  end

  it 'renders the body' do
    mail_contact = ContactFormMailer.send_contact(subject: ['test_subject'], body: ['test_body'], sender: ['test@sender.com'])

    expect(mail_contact.body.encoded).to eq('test_body')
  end
end
