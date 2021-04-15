class ContactForm < Patterns::Form
  attribute :sender, String
  attribute :body, String
  attribute :subject, String

  validates :sender, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :sender, :body, :subject, presence: true

  private

  def persist
    send_mail_from_contact_form
  end 

  def send_mail_from_contact_form
    ContactFormMailer.send_contact(subject: subject, body: body, sender: sender).deliver_now
  end
end