class SetAffiliateCodesForExistingUsers < ActiveRecord::Migration
  def self.up
    say_with_time "Creating affiliate codes..." do
      User.find(:all).each do |u|
        u.set_affiliate_code!
      end
    end
  end

  def self.down
  end
end
