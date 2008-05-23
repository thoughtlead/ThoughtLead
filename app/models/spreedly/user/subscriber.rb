module Spreedly
  module User
    class Subscriber < ActiveResource::Base 
      def self.configure(community)
        self.site = "https://#{community.spreedly_api_key}:X@spreedly.com/api/v3/#{community.use_spreedly_production_site ? 'production' : 'test'}" 
      end
    end
  end
end
