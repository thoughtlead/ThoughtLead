
class ApplicationController < ActionController::Base
  helper :all

  include AuthenticatedSystem
  include ExceptionNotifiable
  include CommunityLocation

  before_filter :login_from_cookie
  protect_from_forgery
  
  private
    def community_is_active
      return redirect_to(community_need_to_activate_url) unless current_community.active
    end
    
    def self.tiny_mce_options
      {
        :options => 
        {   
          :mode => "specific_textareas",
        	:theme => "advanced",
        	:theme_advanced_buttons1 => "bold,italic,|,bullist,numlist,outdent,indent,|,image,|,undo,redo",
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
      return default_file unless File.exist?("#{themes_dir}/#{current_community.subdomain}/#{filename}")
      "/#{themes_dir}/#{current_community.subdomain}/#{filename}"
    end
end
