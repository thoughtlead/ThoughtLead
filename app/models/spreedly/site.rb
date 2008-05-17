module Spreedly
  
  class Site < ActiveResource::Base 
  
    def self.configure(community)
      self.site = "https://#{community.spreedly_api_key}:X@spreedly.com/api/v3" 
    end
    
  end
  
end