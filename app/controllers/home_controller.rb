class HomeController < ApplicationController
  layout 'home'
  
  def index
    @communities = Community.find(:all)
  end
  
end
