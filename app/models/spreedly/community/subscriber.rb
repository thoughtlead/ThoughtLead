module Spreedly
  module Community
    class Subscriber < ActiveResource::Base 
      if Rails.env == "production" || Rails.env == 'staging' 
        self.site = "https://43f5af47198f31ab66334b027b989f997e039865:X@spreedly.com/api/v3/test" 
      else
        self.site = "https://43f5af47198f31ab66334b027b989f997e039865:X@spreedly.com/api/v3/test" 
      end
    end
  end
end
