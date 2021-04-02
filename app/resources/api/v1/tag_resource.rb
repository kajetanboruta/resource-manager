module Api
  module V1
    class TagResource < JSONAPI::Resource
      attributes :name
    end
  end
end