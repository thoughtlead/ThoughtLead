class SubscriptionPlan < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  belongs_to :access_class

  def self.units
    %w( years months days weeks )
  end

  validates_numericality_of :amount, :greater_than => 0
  validates_numericality_of :renewal_period, :only_integer => true, :greater_than => 0
  validates_inclusion_of :renewal_units, :in => units
  validates_numericality_of :trial_period, :only_integer => true, :greater_than_or_equal_to => 0
  validates_inclusion_of :trial_units, :in => units

  def plan_summary
    "#{number_to_currency(self.amount)} per #{renewal_summary}"
  end

  def renewal_summary
    renewal_period == 1 ? renewal_units.singularize : "#{renewal_period} #{renewal_units}"
  end
end
