class SubscriptionPayment < ActiveRecord::Base
  belongs_to :user

  after_create :send_receipt

  def self.find_all_by_community(community)
    all(:conditions => {"users.community_id" => community.id}, :include => "user", :order => "subscription_payments.created_at DESC")
  end

  def self.find_all_by_community_within_date_range(community, start_date, end_date)
    all(:conditions => {"users.community_id" => community.id, "subscription_payments.created_at" => (start_date)..(end_date)}, :include => "user", :order => "subscription_payments.created_at DESC")
  end

  protected

  def send_receipt
    return unless amount > 0
    SubscriptionNotifier.deliver_charge_receipt(self)
    SubscriptionNotifier.deliver_charge_receipt_to_owner(self)
    true
  end
end
