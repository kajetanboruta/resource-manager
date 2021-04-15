require 'rails_helper'

RSpec.describe 'TagReportScheduleForm' do
  context 'when correct email is provided' do
    it 'schedules export of tags through mail' do
      email = 'test@test.com'

      form = TagReportScheduleForm.new(email: email)

      expect(form.save).not_to eq(false)
    end
  end
end
