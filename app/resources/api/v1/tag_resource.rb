module Api
  module V1
    class TagResource < JSONAPI::Resource
      attributes :name, :tag_category_id, :tag_category

      has_one :tag_category

      paginator :paged
      filter :tag_category
      sort :name
    end
  end
end
