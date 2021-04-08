require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe SendExportedTagsWorker, type: :worker do
  it 'creates worker with list of 5 tags' do
    create_list(:tag, 5)

    expect {
      SendExportedTagsWorker.perform_async('mail@mail.mail')
    }.to change(SendExportedTagsWorker.jobs, :size).by(1)
  end
end
