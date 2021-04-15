class TagReportScheduleForm < Patterns::Form
  param_key 'tag'

  attribute :email, String

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  private

  def persist
    schedule_tag_report_mail
  end

  def schedule_tag_report_mail
    SendExportedTagsWorker.perform_at(3.minutes.from_now, email: email)
  end
end
 