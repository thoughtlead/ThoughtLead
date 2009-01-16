class SubscriptionPlan < ActiveRecord::Base
  include RecurringPayment

  belongs_to :access_class

  validates_presence_of :name
  validates_numericality_of :amount, :greater_than => 0
  validates_numericality_of :renewal_period, :only_integer => true, :greater_than => 0
  validates_inclusion_of :renewal_units, :in => units
  validates_numericality_of :trial_period, :only_integer => true, :greater_than_or_equal_to => 0
  validates_inclusion_of :trial_units, :in => units

  default_value_for :renewal_period, 1
  default_value_for :renewal_units, "months"
  default_value_for :trial_period,  0
  default_value_for :trial_units,  "months"
end
