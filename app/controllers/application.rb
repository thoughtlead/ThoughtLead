
class ApplicationController < ActionController::Base
  helper :all
  
  include AuthenticatedSystem
  include ExceptionNotifiable
  include CommunityLocation
  include RomanNumerals
  include WillPaginate
  
  before_filter :login_from_cookie
  before_filter :control_access
  before_filter :invalidate_return_to
  protect_from_forgery
  
  filter_parameter_logging :password, :password_confirmation
  
  protected
   
  def redirect_back(redirect_opts = nil)
    redirect_opts ||= {:controller => 'home'}
    request.env["HTTP_REFERER"] ? redirect_to(request.env["HTTP_REFERER"]) : redirect_to(redirect_opts)
  end
  
  private
  
  def community_is_active
    if current_community && !current_community.active
      redirect_to(community_need_to_activate_url)
    end
  end
  
  def control_access
    ac_object = get_access_controlled_object if defined? get_access_controlled_object
    return if ac_object.nil?
    store_location
    
    unless ac_object.access_class.nil? || logged_in_as_owner?
      unless logged_in? 
        flash[:notice] = "You must login to a premium account or create a new premium account to view this content.<br/>" + 
          "To create a new premium account, first register or login as a free member.<br/>" + 
          "Once you are logged in simply follow the on-screen instructions to access premium content in no time."
        redirect_to login_url
      end
      if logged_in? && !ac_object.access_class.is_accessible_to_someone_with(current_user.access_class)
        flash[:notice] = "You need to upgrade your account if you wish to view premium content."
        redirect_to upgrade_url  
      end
    end
    
    if ac_object.is_registered? && !logged_in?
      flash[:notice] = "You must login or create an account to view that content."
      redirect_to login_url
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
  
end
