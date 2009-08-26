class ApplicationController < ActionController::Base
  include SslRequirement
  include AuthenticatedSystem
  include ExceptionNotifiable
  include CommunityLocation
  include RomanNumerals
  include WillPaginate
  
  before_filter :control_access
  before_filter :invalidate_return_to
  before_filter :set_site_title
  
  before_filter :record_affiliate_actions, :if => :affiliate_tracking_enabled?
  protect_from_forgery

  filter_parameter_logging :password, :password_confirmation, :card

  protected

  def redirect_back(redirect_opts = nil)
    redirect_opts ||= {:controller => 'home'}
    request.env["HTTP_REFERER"] ? redirect_to(request.env["HTTP_REFERER"]) : redirect_to(redirect_opts)
  end

  def set_headline(line = {})
    @headline ||= {:site => nil, :section => nil, :subsection => nil, :content => nil}
    @headline.merge!(line)
  end
  
  def affiliate_tracking_enabled?
    @current_community && @current_community.affiliates_enabled?
  end
  
  def record_affiliate_actions
    if affcode = params[:ac]
      if cookies['TLAFF'] and cookies['TLAFF'] == affcode # Previous visit, record a click on referring user
        record_action(affcode, :click)
      elsif cookies['TLAFF'] and cookies['TLAFF'] != affcode # Previous visit, but referred by another user, record a click on referring user
        record_action(affcode, :click)
      else # No previous visit, record click and unique for referring user, and set cookie
        record_action(affcode, :click)
        record_action(affcode, :unique)
        cookies['TLAFF'] = { :value => affcode, :expires => 3.months.from_now.utc }
      end
    end
  end
  
  def record_action(aff_code, action)
    referrer = User.find_by_affiliate_code(aff_code)
    if referrer
      referrer.referrals.create(:referred_id => (@current_user || nil), :action => action.to_s)
    end
  end

  private
  
  def set_site_title
    if @current_community && current_community.name
      set_headline :site => current_community.name
    else
      set_headline :site => 'ThoughtLead'
    end
  end

  def community_is_active
    if current_community && !current_community.active
      redirect_to(community_need_to_activate_url)
    end
  end

  def control_access
    return if logged_in_as_owner?

    ac_object = get_access_controlled_object if defined? get_access_controlled_object
    return if ac_object.nil?
    store_location

    if logged_in?
      return if ac_object.access_classes.blank?
      if !ac_object.access_classes.blank? && (current_user.access_classes.empty? || !current_user.has_access_to(ac_object))
        flash[:notice] = "You need to upgrade your account to #{ac_object.access_classes.map(&:name).join(" or ")} if you wish to view this content."
        redirect_to upgrade_url and return
      end
    else
      if !ac_object.access_classes.blank?
        flash[:notice] = "You must login to a premium account or create a new premium account to view this content.<br/>" +
        "To create a new premium account, first register or login as a free member.<br/>" +
        "Once you are logged in simply follow the on-screen instructions to access premium content in no time."
        redirect_to login_url and return
      end
      if ac_object.is_registered?
        flash[:notice] = "You must login or create an account to view that content."
        redirect_to login_url and return
      end
    end
  end

  def self.tiny_mce_options
    {
      :options =>
      {
        :mode => "specific_textareas",
        :theme => "advanced",
        :theme_advanced_buttons1 => "bold,italic,|,bullist,numlist,outdent,indent,|,link,image,|,undo,redo",
        :theme_advanced_buttons2 => "",
        :theme_advanced_buttons3 => "",
        :theme_advanced_toolbar_location => "top",
        :theme_advanced_toolbar_align => "left",
        :extended_valid_elements => "a[name|href|target|title|onclick],img[class|src|border=0|alt|title|hspace|vspace|width|height|align|onmouseover|onmouseout|name],hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]"
      }
    }
  end

  def themed_file(filename)
    themes_dir = File.expand_path(File.dirname(__FILE__) + "/../../public/themes")
    default_file = "#{themes_dir}/default/#{filename}"
    return default_file unless current_community
    return default_file unless File.exist?("#{themes_dir}/#{current_community.host}/#{filename}")
    "#{themes_dir}/#{current_community.host}/#{filename}"
  end
  
  def render_custom_page(page)
    @page = page
    if @page.standalone?
      render :text => @page.body, :type => 'text/html'
    else
      set_headline :section => @page.name  
      render :template => 'pages/page'
    end
  end
  
  def render_upsell_page(page)
    @page = page
    if @page.standalone?
      render :text => @page.body, :type => 'text/html'
    else
      set_headline :section => @page.name  
      render :template => 'pages/upsell_page'
    end
  end
end
