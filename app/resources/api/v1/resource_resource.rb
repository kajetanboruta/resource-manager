module Api
  module V1
    class ResourceResource < JSONAPI::Resource
      attributes :name, :description, :url
    end
  end
end