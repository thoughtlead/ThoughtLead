class SubscriptionNotifier < ActionMailer::Base
  include ActionView::Helpers::NumberHelper

  def self.deliver_charge_failure(subscription)
    deliver_charge_failure_to_user(subscription)
    deliver_charge_failure_to_owner(subscription)
  end

  def self.deliver_charge_receipt(subscription_payment)
    deliver_charge_receipt_to_user(subscription_payment)
    deliver_charge_receipt_to_owner(subscription_payment)
  end

  def self.deliver_trial_expiring(subscription)
    deliver_trial_expiring_to_user(subscription)
    deliver_trial_expiring_to_owner(subscription)
  end

  def charge_failure_to_user(subscription)
    setup_email subscription.user.community, subscription.user
    subject "Your #{subscription.user.community.name} renewal failed"
    body :subscription => subscription
  end

  def charge_failure_to_owner(subscription)
    setup_email subscription.user.community, subscription.user.community.owner
    subject "Charge failed for #{subscription.user.display_name} on #{subscription.user.community.name}"
    body :subscription => subscription
  end

  def charge_receipt_to_user(subscription_payment)
    setup_email subscription_payment.user.community, subscription_payment.user
    subject "Your #{subscription_payment.user.community.name} invoice"
    body :user => subscription_payment.user, :subscription => subscription_payment.user.subscription, :amount => subscription_payment.amount
  end

  def charge_receipt_to_owner(subscription_payment)
    setup_email subscription_payment.user.community, subscription_payment.user.community.owner
    subject "Invoice sent to #{subscription_payment.user.display_name}"
    body :user => subscription_payment.user, :subscription => subscription_payment.user.subscription, :amount => subscription_payment.amount
  end

  def trial_expiring_to_user(subscription)
    setup_email subscription.user.community, subscription.user
    subject "Trial period expiring"
    body :subscription => subscription
  end

  def trial_expiring_to_owner(subscription)
    setup_email subscription.user.community, subscription.user.community.owner
    subject "Trial period expiring for #{subscription.user.display_name} on #{subscription.user.community.name}"
    body :subscription => subscription
  end

  private

  def setup_email(community, to)
    from "#{community.name} <do-not-reply@#{community.host}>"
    sent_on Time.now
    recipients to.respond_to?(:email) ? to.email : to
    headers "x-custom-ip-tag" => "thoughtlead"
  end
end
