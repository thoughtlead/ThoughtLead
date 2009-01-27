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

  context "" do
    setup do
      ActionMailer::Base.deliveries = []
    end

    context "with a trial subscription expiring soon" do
      setup do
        @subscription = Subscription.make(:state => "trial", :next_renewal_at => 7.days.from_now)
      end

      should "list it as a trial expiring soon" do
        assert Subscription.trials_expiring_soon.include?(@subscription)
      end

      should "send email when notifying expiring trials" do
        Subscription.notify_expiring_trials

        assert_sent_email do |email|
          email.subject =~ /Trial period expiring/ && email.to.include?(@subscription.user.email)
        end
      end
    end

    context "with a trial subscription not expiring soon" do
      setup do
        @subscription = Subscription.make(:state => "trial", :next_renewal_at => 12.days.from_now)
      end

      should "not have any trials expiring soon" do
        assert Subscription.trials_expiring_soon.empty?
      end

      should "send not email when notifying expiring trials" do
        Subscription.notify_expiring_trials
        assert_did_not_send_email
      end
    end

    context "with a subscription due today" do
      setup do
        @subscription = Subscription.make(:state => "active", :next_renewal_at => Date.today, :renewal_period => 1, :renewal_units => "months")
      end

      should "list it as active and due" do
        assert Subscription.active_due.include?(@subscription)
      end

      context "after successfully charging the subscription" do
        setup do
          ActiveMerchant::Billing::AuthorizeNetCimGateway.any_instance.expects(:purchase).returns(stub(:success? => true, :authorization => 'foo'))
          Subscription.charge_due_subscriptions
        end

        should "update the next renewal date" do
          @subscription.reload
          assert_equal 1.month.from_now.to_date, @subscription.next_renewal_at
        end

        should "send email with receipt" do
          assert_sent_email do |email|
            email.subject =~ /Your #{@subscription.user.community.name} invoice/ && email.to.include?(@subscription.user.email)
          end
        end
      end

      context "after charging the subscription fails" do
        setup do
          ActiveMerchant::Billing::AuthorizeNetCimGateway.any_instance.expects(:purchase).returns(stub(:success? => false, :message => "Insufficient cheese."))
          Subscription.charge_due_subscriptions
        end

        should "set the user state to pending" do
          @subscription.reload
          assert_equal "pending", @subscription.state
        end

        should "set the user's access class back to Registered" do
          assert_nil @subscription.user.access_class
        end

        should "send email with charge failure" do
          assert_sent_email do |email|
            email.subject =~ /Your #{@subscription.user.community.name} renewal failed/ && email.to.include?(@subscription.user.email)
          end
        end
      end
    end

    context "with a subscription not due today" do
      setup do
        @subscription = Subscription.make(:state => "active", :next_renewal_at => Date.tomorrow, :renewal_period => 1, :renewal_units => "months")
        ActiveMerchant::Billing::AuthorizeNetCimGateway.any_instance.expects(:purchase).never
      end

      should "not list it as active and due" do
        assert Subscription.active_due.empty?
      end

      should "not charge the subscription" do
        Subscription.charge_due_subscriptions
      end

      should "not update the next renewal date" do
        Subscription.charge_due_subscriptions
        @subscription.reload
        assert_equal Date.tomorrow, @subscription.next_renewal_at
      end

      should "not send email with receipt" do
        Subscription.charge_due_subscriptions
        assert_did_not_send_email
      end
    end
  end
end
