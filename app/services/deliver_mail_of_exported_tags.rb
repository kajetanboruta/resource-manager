class DeliverMailOfExportedTags < Patterns::Service
  def initialize(email, tags = Tag.all)
    @email = email
    @tags = tags
  end

  def call
    UserMailer.send_export(email, tags).deliver_now
  end

  private

  attr_reader :email, :tags
end
