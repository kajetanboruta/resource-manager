require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ServiceWorker, type: :worker do
  it 'creates worker' do
    create_list(:tag, 5)
    ServiceWorker.perform_in(1.minute, 'mail@mail.mail', Tag.all)
    # work.perform_in(1.minute, 'mail@mail.mail')

    expect do
      ServiceWorker.perform_async('mail@mail.mail')
    end.to change(ServiceWorker.jobs, :size).by(1)
  end

  it 'drains ServiceWorker and checks if new ServiceWorker was created' do
    ServiceWorker.drain

    assert_equal 0, ServiceWorker.jobs.size
    ServiceWorker.perform_async('mail@mail.mail')
    assert_equal 1, ServiceWorker.jobs.size
  end

  it 'sends mail' do
    work = ServiceWorker.new
    work.perform('mail@mail.mail')
    UserMailer.send('mail@mail.mail')
    # expect(mail.subject).to eq('')
    expect(mail.to).to eq('mail@mail.mail')
    # expect(mail.from).to eq('')
  end
end
