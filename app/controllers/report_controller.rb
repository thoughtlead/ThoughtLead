require 'fastercsv'

class ReportController < ApplicationController
  
  before_filter :owner_login_required
  
  # example action to return the contents
  # of a table in CSV format
  def export_users
    since = Date.new(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i)
    active = params[:premium] == 'true'
    users = User.find(:all, :conditions => ["created_at >= ? and community_id = ? and active = ?", since, current_community.id, active])
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
  
end
