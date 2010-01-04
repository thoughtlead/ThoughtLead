class AdminController < ApplicationController
  before_filter :owner_login_required

  def edit_community
    @community = current_community

    return if request.get?

    return unless @community.update_attributes(params[:community])

    flash[:notice] = "Community Settings Saved"
    redirect_to edit_community_url
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

    if params[:premium] == 'true'
      users = User.find(:all, :include => :user_classes, :conditions => ["created_at >= ? and community_id = ? and user_classes.access_class_id is not null", since, current_community.id])
    else
      users = User.find(:all, :conditions => ["created_at >= ? and community_id = ?", since, current_community.id])
    end
    csv_string = FasterCSV.generate do |csv|
      csv << ["first_name","last_name","email", "membership level"]
      users.each do |u|
        ac_names = u.access_class_names.join("|") unless u.user_classes.empty?
        csv << [u.first_name, u.last_name, u.email, ac_names || 'Registered']
      end
    end
    send_data csv_string, :type => "text/plain",
    :filename=>"export_users.csv",
    :disposition => 'attachment'
  end
  
  def export_affiliates
    begin
      since = Date.new(params[:date][:year].to_i, params[:date][:month].to_i, 1)
      til = since.end_of_month
    rescue ArgumentError
      flash[:notice] = "You have entered an invalid date."
      redirect_to select_affiliate_reports_url
      return
    end
    
    if since > Date.today
      flash[:notice] = "You can't create reports for future months (yet!)"
      redirect_to select_affiliate_reports_url and return
    end
    

    users = User.find(:all, :include => :referrals, :conditions => {'users.community_id' => current_community.id, 'affiliate_actions.created_at' => since..til})
    
    if users.empty?
      flash[:notice] = "Sorry, no affiliate activity for #{since.strftime('%B %Y')}"
      redirect_to select_affiliate_reports_url and return
    end
    
    csv_string = FasterCSV.generate do |csv|
      csv << ["first_name","last_name","email", "clicks", "uniques", "signups", "upgrades"]
      users.each do |u|
        csv << [u.first_name, u.last_name, u.email, u.clicks.count, u.uniques.count, u.signups.count, u.upgrades.count]
      end
    end
    send_data csv_string, :type => "text/csv",
    :filename=>"export_affiliates.csv",
    :disposition => 'attachment'
  end

  def select_exported_users
  end
  
  def select_affiliate_reports
    @current_month_totals = {
      :clicks => current_community.clicks.count 
    }
  end
end
