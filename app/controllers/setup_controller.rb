class SetupController < ApplicationController
  layout "community_home"

  before_filter :community_is_active, :except => [ :index ]

  def index
    @community = Community.new
    @user = User.new
    

  end
  
  def billing
    @community = Community.new(params[:community])
    @user = User.new(params[:user])
    number = '4007000000027' #Authorize.net test card, non-error-producing
    billing_address = { :name => 'Bob Smith', :address1 => '123 Down the Road',
      :city => 'San Francisco', :state => 'CA',
      :country => 'US', :zip => '23456', :phone => '(555)555-5555' }

    credit_card = ActiveMerchant::Billing::CreditCard.new(
    :number => number,
    :month => 10,
    :year => 2010,
    :first_name => 'Bob',
    :last_name => 'Smith',
    :verification_value => '111', #verification codes are now required
    :type => 'visa'    
    )
    
    @card = @credit_card
  end

end
