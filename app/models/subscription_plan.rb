class SubscriptionPlan < ActiveResource::Base 
  
  def self.api_key=(api_key)
    @api_key = api_key
    if Rails.env == "production" || Rails.env == 'staging' 
      self.site = "https://#{@api_key}:X@spreedly.com/api/v3/test" 
    else
      self.site = "https://#{@api_key}:X@spreedly.com/api/v3/test" 
    end
  end
end
