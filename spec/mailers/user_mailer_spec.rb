require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  it 'renders the headers' do
    create(:tag, name: 'ruby')

    mail = UserMailer.send_export(['to@example.org'], Tag.all)

    expect(mail.subject).to eq('Tags')
    expect(mail.to).to eq(['to@example.org'])
    expect(mail.from).to eq(['from@example.com'])
  end

  it 'renders the attachments' do
    mail = UserMailer.send_export(['to@example.org'], Tag.all)

    expect(mail.attachments.count).to eq(1)
    expect(mail.attachments[0].filename).to eq('Tags.xlsx')
  end
end
