class ErrorSerializer
  def initialize(error_collection)
    @error_collection = error_collection
  end

  def serialize
    errors_array = error_collection.errors.messages.flat_map do |field, errors|
      errors.map do |error_message|
        {
          status: '422',
          source: { pointer: "/data/attributes/#{field}" },
          detail: "#{field} #{error_message}"
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
