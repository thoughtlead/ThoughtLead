require File.dirname(__FILE__) + '/../test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  def test_renewal_summary
    subscription = subscriptions :premium

    subscription.renewal_period = 1
    subscription.renewal_units = "months"

    assert_equal("month", subscription.renewal_summary)

    subscription.renewal_units = "days"
    assert_equal("day", subscription.renewal_summary)

    subscription.renewal_units = "weeks"
    assert_equal("week", subscription.renewal_summary)

    subscription.renewal_units = "years"
    assert_equal("year", subscription.renewal_summary)

    subscription.renewal_period = 6
    assert_equal("6 years", subscription.renewal_summary)

    subscription.renewal_units = "months"
    assert_equal("6 months", subscription.renewal_summary)
  end

  def test_summary
    subscription = subscriptions :premium

    subscription.amount = 10.00
    subscription.renewal_period = 1
    subscription.renewal_units = "weeks"

    assert_equal("$10.00 per week", subscription.summary)

    subscription.renewal_units = "months"
    assert_equal("$10.00 per month", subscription.summary)

    subscription.renewal_period = 6
    assert_equal("$10.00 per 6 months", subscription.summary)
  end
end
