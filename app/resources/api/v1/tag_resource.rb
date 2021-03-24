module Api
  module V1
    class TagResource < JSONAPI::Resource
      attributes :name
      has_one :tag_category
    end
  end
end
