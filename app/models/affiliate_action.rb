class AffiliateAction < ActiveRecord::Base
  belongs_to :referrer, :class_name => 'User', :foreign_key => 'referrer_id'
  belongs_to :referred, :class_name => 'User', :foreign_key => 'referred_id'
end
