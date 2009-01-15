class SubscriptionPayment < ActiveRecord::Base
  belongs_to :user

  after_create :send_receipt

  protected

  def send_receipt
    return unless amount > 0
    SubscriptionNotifier.deliver_charge_receipt(self)
    true
  end
end