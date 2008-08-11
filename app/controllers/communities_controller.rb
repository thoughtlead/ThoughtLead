class CommunitiesController < ApplicationController
  
  layout :community_layout

  before_filter :community_is_active, :except => [ :need_to_activate, :new, :create, :changed_on_spreedly, :choose_plan, :index ]
  before_filter :super_admin_login_required, :only => [ :index, :toggle_community_activation ]
  skip_before_filter :verify_authenticity_token, :only => :changed_on_spreedly
  
  def index
    @communities = Community.find(:all)
  end
  
  def current_community_home
    render :file => themed_file("community_home.html.erb"), :layout => true
  end
  
  def current_community_about
    render :file => themed_file("community_about.html.erb"), :layout => true
  end
  
  def current_community_contact
    render :file => themed_file("community_contact.html.erb"), :layout => true
  end
  
  def new
    @community = Community.new
    @user = User.new
  end
  
  def create
    ActiveRecord::Base.current_community = :valid
    @user = User.new(params[:user])
    @community = Community.new(params[:community])

    @community.valid?
    return render(:action => :new) unless @user.valid? && @community.valid?
    
    @user.save
    @community.owner = @user
    @community.save
    
    Mailer.deliver_community_created(@community, community_dashboard_url(@community))
    
    flash[:notice] = "Successfully created your community."
    ActiveRecord::Base.current_community = @community    
    #TODO this is broken for local machines as it does not include the port
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
  
  def toggle_activation
    id = params[:id]
    community = Community.find_by_id(id)
    if (community != current_community)
      community.active = !community.active
      community.save
    end
    redirect_to communities_url
  end
  
  
  private
    def upgrade_url(plan_id)
      "https://spreedly.com/thoughtlead-test/subscribers/#{current_community.id}/subscribe/#{plan_id}/#{current_community.host}?return_url=#{community_dashboard_url(current_community)}"
    end
  
    def community_layout
      ['new', 'choose_plan', 'index'].include?(params[:action]) ? 'community_home' : 'application'
    end
  
    def plan_id
      case params[:selected_plan]
        when 'monthly' then '56'
        when 'quarterly' then '57'
      end
    end
end
