class CommunitiesController < ApplicationController
  
  layout :community_layout
  before_filter :community_is_active, :except => [ :need_to_activate, :new, :create, :changed_on_spreedly, :choose_plan ]
  skip_before_filter :verify_authenticity_token, :only => :changed_on_spreedly
  before_filter :login_required, :only => :choose_plan
  
  def index
    @communities = Community.find(:all)
  end
  
  def new
    @community = Community.new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @community = Community.new(params[:community])

    @community.valid?
    return render(:action => :new) unless @user.valid? && @community.valid?
    
    @user.save
    @community.owner = @user
    @community.save
    Mailer.deliver_community_created(@community, community_dashboard_url(@community))
    
    flash[:notice] = "Successfully created your community."
    redirect_to community_dashboard_url(@community)
  end
  
  def changed_on_spreedly
    subscriber_ids = params[:subscriber_ids].split(",")
    subscriber_ids.each do | each |
      community = Community.find_by_id(each)
      community.refresh_from_spreedly if community
    end

    head(:ok)
  end
  
  def choose_plan
    return if request.get? 
    return if params[:selected_plan].blank?

    redirect_to "https://spreedly.com/thoughtlead-test/subscribers/#{current_user.community.id}/subscribe/#{plan_id}/#{current_user.community}"  
  end
  
  
  private
    def community_layout
      params[:action] == 'new' ? 'home' : 'application'
    end
  
    def plan_id
      case params[:selected_plan]
        when 'monthly' then '56'
        when 'quarterly' then '57'
      end
    end
  
end
