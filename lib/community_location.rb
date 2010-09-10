module CommunityLocation
  include HostHelper
  attr_reader :current_community
  
  def self.included(controller)
    controller.helper_method(:community_dashboard_url, :current_community)
    controller.before_filter(:find_community)
  end
  
  private
  
  def community_dashboard_url(community = current_community, use_ssl = request.ssl?)
   (use_ssl ? "https://" : "http://") + community_host(community)
  end
  
  def community_login_url(community = current_community, use_ssl = request.ssl?)
      "#{community_dashboard_url(community, use_ssl)}/login"
  end
  
  def community_host(community)
    community.host
  end
  
  def community_domain
    community_domain = ""
    #start_index = (Rails.env == 'staging') ? 0 : 1
    start_index = 1
    community_domain << request.subdomains[start_index..-1].join(".") + "." if request.subdomains.size > 1
    community_domain << request.domain + request.port_string
  end
  
  def find_community
    host = host_from(request)
    logger.info("Looking up community for #{host}")
    if host.blank? or host == $app_host
      @current_community = nil
    else
      @current_community = Community.find_by_host(host)
      unless @current_community
        logger.error("Could not finr community for #{host}")
        render_404
      end
    end
  end
  
end