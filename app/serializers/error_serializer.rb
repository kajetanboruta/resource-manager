class ErrorSerializer
  def initialize(error_collection)
    @error_collection = error_collection
  end

  def serialize
    errors_array = error_collection.errors.messages.flat_map do |field, errors|
      data_element = field.ends_with?('_id') ? "relationships/#{field.to_s.dasherize.delete_suffix('-id')}/data/id" : "attributes/#{field}"

      errors.map do |error_message|
        {
          status: '422',
          source: { pointer: "/data/#{data_element}" },
          detail: "#{field.to_s.humanize} #{error_message}"
        }
      end
    end
    {
      errors: errors_array
    }
  end

  private

  attr_reader :error_collection
end
