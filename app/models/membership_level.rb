class MembershipLevel < ActiveRecord::Base
  belongs_to :community
end