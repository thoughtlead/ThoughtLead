class SubscriptionNotifier < ActionMailer::Base
  include ActionView::Helpers::NumberHelper

  def setup_email(to, subject)
    @from = "#{APP_NAME} <do-not-reply@#{APP_DOMAIN}>"
    @subject = subject
    @sent_on = Time.now
    @recipients = to.respond_to?(:email) ? to.email : to
    @headers["x-custom-ip-tag"] = "thoughtlead"
  end

  def charge_failure(subscription)
    setup_email(subscription.user, "Your #{subscription.user.community.name} renewal failed")
    @body = { :subscription => subscription }
  end

  def charge_failure_to_owner(subscription)
    setup_email(subscription.user.community.owner, "Charge failed for #{subscription.user.display_name} on #{subscription.user.community.name}")
    @body = { :subscription => subscription }
  end

  def charge_receipt(subscription_payment)
    setup_email(subscription_payment.user, "Your #{subscription_payment.user.community.name} invoice")
    @body = { :user => subscription_payment.user, :subscription => subscription_payment.user.subscription, :amount => subscription_payment.amount }
  end

  def charge_receipt_to_owner(subscription_payment)
    setup_email(subscription_payment.user.community.owner, "Invoice sent to #{subscription_payment.user.display_name}")
    @body = { :user => subscription_payment.user, :subscription => subscription_payment.user.subscription, :amount => subscription_payment.amount }
  end

  def trial_expiring(subscription)
    setup_email(subscription.user, 'Trial period expiring')
    @body = { :subscription => subscription }
  end

  def trial_expiring_to_owner(subscription)
    setup_email(subscription.user.community.owner, "Trial period expiring for #{subscription.user.display_name} on #{subscription.user.community.name}")
    @body = { :subscription => subscription }
  end
end
