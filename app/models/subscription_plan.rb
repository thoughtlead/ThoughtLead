class SubscriptionPlan < ActiveRecord::Base
  belongs_to :access_class

  validates_numericality_of :renewal_period, :only_integer => true, :greater_than => 0
  validates_inclusion_of :renewal_units, :in => %w( years months days weeks )
  validates_numericality_of :trial_period, :only_integer => true, :greater_than_or_equal_to => 0
  validates_inclusion_of :trial_units, :in => %w( years months days weeks )
end
