module Api
  module V1
    class LeadResource < JSONAPI::Resource
      attributes :name
    end
  end
end