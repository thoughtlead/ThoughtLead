require File.dirname(__FILE__) + '/../test_helper'

class SubscriptionPlanTest < ActiveSupport::TestCase
  def test_renewal_summary
    plan = subscription_plans :c1_premium_monthly

    plan.renewal_period = 1
    plan.renewal_units = "months"

    assert_equal("month", plan.renewal_summary)

    plan.renewal_units = "days"
    assert_equal("day", plan.renewal_summary)

    plan.renewal_units = "weeks"
    assert_equal("week", plan.renewal_summary)

    plan.renewal_units = "years"
    assert_equal("year", plan.renewal_summary)

    plan.renewal_period = 6
    assert_equal("6 years", plan.renewal_summary)

    plan.renewal_units = "months"
    assert_equal("6 months", plan.renewal_summary)
  end

  def test_trial_summary
    plan = subscription_plans :c1_premium_monthly

    plan.renewal_period = 1
    plan.renewal_units = "months"
    plan.trial_period = 3
    plan.trial_units = "years"

    assert_equal(" with a free trial period of 3 years", plan.trial_summary)

    plan.trial_units = "days"
    assert_equal(" with a free trial period of 3 days", plan.trial_summary)

    plan.trial_units = "weeks"
    assert_equal(" with a free trial period of 3 weeks", plan.trial_summary)

    plan.trial_units = "months"
    assert_equal(" with a free trial period of 3 months", plan.trial_summary)

    plan.trial_period = 1
    assert_equal(" with a free trial period of 1 month", plan.trial_summary)

    plan.trial_units = "days"
    assert_equal(" with a free trial period of 1 day", plan.trial_summary)
  end

  def test_summary
    plan = subscription_plans :c1_premium_monthly

    plan.amount = 10.00
    plan.renewal_period = 1
    plan.renewal_units = "weeks"

    assert_equal("$10.00 per week", plan.summary)

    plan.renewal_units = "months"
    assert_equal("$10.00 per month", plan.summary)

    plan.renewal_period = 6
    assert_equal("$10.00 per 6 months", plan.summary)
  end
end
