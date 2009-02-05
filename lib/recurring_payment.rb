module RecurringPayment
  include ActionView::Helpers::NumberHelper

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def units
      %w( years months days weeks )
    end
  end

  def summary
    "#{number_to_currency(self.amount)} per #{renewal_summary}#{trial_summary}"
  end

  def renewal_summary
    renewal_period == 1 ? renewal_units.singularize : "#{renewal_period} #{renewal_units}"
  end

  def trial_summary
    if defined?(trial_period) && defined?(trial_units) && trial_period != 0
      " with a free trial period of #{trial_period} #{trial_period == 1 ? trial_units.singularize : trial_units}"
    end
  end
end
