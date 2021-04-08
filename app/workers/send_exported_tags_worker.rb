class SendExportedTagsWorker
  include Sidekiq::Worker

  def perform(email)
    DeliverMailOfExportedTags.call(email)
  end
end