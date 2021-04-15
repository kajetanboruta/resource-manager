class ContactFormMailer < ApplicationMailer
  RECIPIENT_EMAIL = 'recipient@test.com'

  default to: RECIPIENT_EMAIL

  def send_contact(subject:, body:, sender:)
    mail(subject: subject, body: body, from: sender, reply_to: sender)
  end
end