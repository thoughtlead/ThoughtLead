class CommunitiesController < ApplicationController
  
  layout :community_layout

  before_filter :community_is_active, :except => [ :need_to_activate, :new, :create, :changed_on_spreedly, :choose_plan, :index ]
  skip_before_filter :verify_authenticity_token, :only => :changed_on_spreedly
  
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
    redirect_to community_login_url(@community)
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
    return if request.get? || params[:selected_plan].blank?
    redirect_to "https://spreedly.com/thoughtlead-test/subscribers/#{current_community.id}/subscribe/#{plan_id}/#{current_community}"  
  end
  
  def need_to_activate
    redirect_to community_home_url if current_community.active?
    @free_trial_url = upgrade_url(55)
    @upgrade_url = upgrade_url(56)
  end
  
  private
    def upgrade_url(plan_id)
      "https://spreedly.com/thoughtlead-test/subscribers/#{current_community.id}/subscribe/#{plan_id}/#{current_community.subdomain}?return_url=#{community_dashboard_url(current_community)}"
    end
  
    def community_layout
      ['new', 'choose_plan', 'index'].include?(params[:action]) ? 'home' : 'application'
    end
  
    def plan_id
      case params[:selected_plan]
        when 'monthly' then '56'
        when 'quarterly' then '57'
      end
    end
  
end
