class TagSerializer
  include AbstractController::Rendering

  def initialize(tags)
    @tags = tags
  end

  def to_xlsx
    render_to_string layout: false,
    handlers: [:axlsx],
    formats: [:xlsx],
    # template: 'views/api/v1/tags_export/tags',
    locals: { tags: tags }
  end

  private

  attr_reader :tags
end
