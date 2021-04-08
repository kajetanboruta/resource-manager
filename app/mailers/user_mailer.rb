class UserMailer < ApplicationMailer
  def send_export(email, tags)
    xlsx = render_to_string layout: false,
                            handlers: [:axlsx],
                            formats: [:xlsx],
                            template: 'api/v1/tags_export/tags',
                            locals: { tags: tags }
    attachments['Tags.xlsx'] = { mime_type: Mime[:xlsx], content: xlsx }
    mail to: email, subject: 'Tags', body: 'Your export is located in the attachment.'
  end
end
