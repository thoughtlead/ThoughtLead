class SubscriptionPaymentsController < ApplicationController
  helper AdminHelper, UsersHelper
  before_filter :owner_login_required

  def index
    if params[:user_id]
      params[:user_id].gsub!('-','.')
      @user = User.find_by_login(params[:user_id])
      @subscription_payments = @user.subscription_payments
    elsif (params[:start_date] && params[:end_date])
      @start_date = "#{params[:start_date][:year]}-#{params[:start_date][:month]}-#{params[:start_date][:day]}"
      @end_date = "#{params[:end_date][:year]}-#{params[:end_date][:month]}-#{params[:end_date][:day]}"
      @subscription_payments = SubscriptionPayment.find_all_by_community_within_date_range(current_community, @start_date, @end_date)
    else
      @subscription_payments = SubscriptionPayment.find_all_by_community(current_community)
    end
  end
end
