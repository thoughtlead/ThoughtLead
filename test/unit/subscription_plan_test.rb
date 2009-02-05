require File.dirname(__FILE__) + '/../test_helper'

class SubscriptionPlanTest < ActiveSupport::TestCase
  context "A Subscription Plan" do
    setup do
      @plan = SubscriptionPlan.new
      @plan.amount = 10.00
      @plan.renewal_period = 2
      @plan.renewal_units = "months"
    end

    should "have a renewal summary that includes the correct units" do
      assert_equal("2 months", @plan.renewal_summary)

      @plan.renewal_units = "days"
      assert_equal("2 days", @plan.renewal_summary)

      @plan.renewal_units = "weeks"
      assert_equal("2 weeks", @plan.renewal_summary)

      @plan.renewal_units = "years"
      assert_equal("2 years", @plan.renewal_summary)
    end

    should "not include the number and be singular in renewal summary when renewal period is only 1" do
      @plan.renewal_period = 1
      assert_equal("month", @plan.renewal_summary)

      @plan.renewal_units = "days"
      assert_equal("day", @plan.renewal_summary)

      @plan.renewal_units = "weeks"
      assert_equal("week", @plan.renewal_summary)

      @plan.renewal_units = "years"
      assert_equal("year", @plan.renewal_summary)
    end

    should "include the amount in the summary" do
      assert_equal("$10.00 per 2 months", @plan.summary)
    end

    should "not include the number and be singular in summary when renewal period is only 1" do
      @plan.renewal_period = 1
      assert_equal("$10.00 per month", @plan.summary)
    end

    should "display correct unit in summary" do
      @plan.renewal_units = "days"
      assert_equal("$10.00 per 2 days", @plan.summary)

      @plan.renewal_units = "weeks"
      assert_equal("$10.00 per 2 weeks", @plan.summary)
    end

    context "with a trial period" do
      setup do
        @plan.trial_period = 3
        @plan.trial_units = "years"
      end

      should "have a trial summary that includes the correct units" do
        assert_equal(" with a free trial period of 3 years", @plan.trial_summary)

        @plan.trial_units = "days"
        assert_equal(" with a free trial period of 3 days", @plan.trial_summary)

        @plan.trial_units = "weeks"
        assert_equal(" with a free trial period of 3 weeks", @plan.trial_summary)

        @plan.trial_units = "months"
        assert_equal(" with a free trial period of 3 months", @plan.trial_summary)
      end

      should "be singular in trial summary when trial period is only 1" do
        @plan.trial_period = 1
        assert_equal(" with a free trial period of 1 year", @plan.trial_summary)

        @plan.trial_units = "days"
        assert_equal(" with a free trial period of 1 day", @plan.trial_summary)

        @plan.trial_units = "weeks"
        assert_equal(" with a free trial period of 1 week", @plan.trial_summary)

        @plan.trial_units = "months"
        assert_equal(" with a free trial period of 1 month", @plan.trial_summary)
      end
    end
  end
end
