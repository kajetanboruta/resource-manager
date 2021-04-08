class UserMailer < ApplicationMailer
  def send_export(email, tags)
    attachments['tags.xlsx'] = { mime_type: Mime[:xlsx], content: TagSerializer.new(tags).to_xlsx }
    mail to: email, subject: 'Tags', body: 'aaa'
  end
end
