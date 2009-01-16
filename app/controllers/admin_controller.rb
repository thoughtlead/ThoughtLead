class AdminController < ApplicationController
  before_filter :owner_login_required

  def edit_community
    @community = current_community

    return if request.get?

    return unless @community.update_attributes(params[:community])

    flash[:notice] = "Community Settings Saved"
    redirect_to edit_community_url
  end

  def access_levels
    @community = current_community
  end

  def create_access_level
    @community = current_community

    highest_order_access_class = @community.access_classes.first(:order => "`order` DESC")
    new_order = highest_order_access_class.nil? ? "1" : highest_order_access_class.order + 1
    access_class = @community.access_classes.build(:name => params[:name], :order => new_order)
    params[:children].each do |child_id|
      access_class.children << AccessClass.find(child_id) unless child_id == ""
    end

    if access_class.save
      flash[:notice] = "Access Level \"#{access_class.name}\" created."
      redirect_to access_levels_url
    end
  end

  def subscription_plans

  end

  def export_users
    begin
      since = Date.new(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i)
    rescue ArgumentError
      flash[:notice] = "You have entered an invalid date."
      redirect_to select_exported_users_url
      return
    end

    premium_condition = params[:premium] == 'true' ? "access_class_id is not null" : "access_class_id is null"
    users = User.find(:all, :conditions => ["created_at >= ? and community_id = ? and " + premium_condition, since, current_community.id])
    csv_string = FasterCSV.generate do |csv|
      csv << ["first_name","last_name","email"]
      users.each do |u|
        csv << [u.first_name, u.last_name, u.email]
      end
    end
    send_data csv_string, :type => "text/plain",
    :filename=>"export_users.csv",
    :disposition => 'attachment'
  end

  def select_exported_users
  end
end
