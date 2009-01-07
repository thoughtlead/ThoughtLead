class AccessClass < ActiveRecord::Base
  belongs_to :community
  
  def higher_than(other_level)
    return true if other_level.nil? 
    self.order > other_level.order
  end
end