class Page < ActiveRecord::Base
  belongs_to :community
  
  def to_param
    page_path
  end
end
