class HomeController < ApplicationController
  layout 'home'
  session :off, :only => :status
  
  def index
    @communities = Community.find(:all)
  end
  
  def status
    render :text => "OK"
  end
  
end
