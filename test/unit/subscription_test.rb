require File.dirname(__FILE__) + '/../test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  context "A Subscription" do
    setup do
      @subscription = Subscription.new
      @subscription.amount = 10.00
      @subscription.renewal_period = 2
      @subscription.renewal_units = "months"
    end

    should "have a renewal summary that includes the correct units" do
      assert_equal("2 months", @subscription.renewal_summary)

      @subscription.renewal_units = "days"
      assert_equal("2 days", @subscription.renewal_summary)

      @subscription.renewal_units = "weeks"
      assert_equal("2 weeks", @subscription.renewal_summary)

      @subscription.renewal_units = "years"
      assert_equal("2 years", @subscription.renewal_summary)
    end

    should "not include the number and be singular in renewal summary when renewal period is only 1" do
      @subscription.renewal_period = 1
      assert_equal("month", @subscription.renewal_summary)

      @subscription.renewal_units = "days"
      assert_equal("day", @subscription.renewal_summary)

      @subscription.renewal_units = "weeks"
      assert_equal("week", @subscription.renewal_summary)

      @subscription.renewal_units = "years"
      assert_equal("year", @subscription.renewal_summary)
    end

    should "include the amount in the summary" do
      assert_equal("$10.00 per 2 months", @subscription.summary)
    end

    should "not include the number and be singular in summary when renewal period is only 1" do
      @subscription.renewal_period = 1
      assert_equal("$10.00 per month", @subscription.summary)
    end

    should "display correct unit in summary" do
      @subscription.renewal_units = "days"
      assert_equal("$10.00 per 2 days", @subscription.summary)

      @subscription.renewal_units = "weeks"
      assert_equal("$10.00 per 2 weeks", @subscription.summary)
    end
  end

  context "with a trial subscription expiring soon" do
    setup do
      @subscription = Subscription.make(:state => "trial", :next_renewal_at => 7.days.from_now)
    end

    should "be listed in named scope" do
      assert Subscription.trials_expiring_soon.include?(@subscription)
    end

    should "send email when notifying expiring trials" do
      Subscription.notify_expiring_trials

      assert_sent_email do |email|
        email.subject =~ /Trial period expiring/ && email.to.include?(@subscription.user.email)
      end
    end
  end
end
