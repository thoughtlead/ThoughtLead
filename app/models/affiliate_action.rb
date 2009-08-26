class AffiliateAction < ActiveRecord::Base
  belongs_to :referrer, :class_name => 'User', :foreign_key => 'referrer_id'
  belongs_to :referred, :class_name => 'User', :foreign_key => 'referred_id'
  
  named_scope :this_month, :conditions => { :created_at => Time.now.utc.beginning_of_month..Time.now.utc }
  named_scope :last_month, :conditions => { 
    :created_at => (Time.now.utc - 1.month).beginning_of_month..(Time.now.utc - 1.month).end_of_month }
  named_scope :months_ago, lambda { |months_ago|
    t = Time.now.utc - months_ago.months
    { :conditions => { :created_at => t.beginning_of_month..t.end_of_month } }
  }
end
