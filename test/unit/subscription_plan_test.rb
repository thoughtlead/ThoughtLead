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

  def test_plan_summary
    plan = subscription_plans :c1_premium_monthly

    plan.amount = 10.00
    plan.renewal_period = 1
    plan.renewal_units = "weeks"

    assert_equal("$10.00 per week", plan.plan_summary)

    plan.renewal_units = "months"
    assert_equal("$10.00 per month", plan.plan_summary)

    plan.renewal_period = 6
    assert_equal("$10.00 per 6 months", plan.plan_summary)
  end
end
