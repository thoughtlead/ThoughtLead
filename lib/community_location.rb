module CommunityLocation
  include SubdomainHelper
  attr_reader :current_community
  
  def self.included(controller)
    controller.helper_method(:community_dashboard_url, :current_community)
    controller.before_filter(:find_community)
  end

  private
  
    def community_dashboard_url(community = current_community, use_ssl = request.ssl?)
      (use_ssl ? "https://" : "http://") + community_host(community)
    end

    def community_host(community)
      community_host = ""
      community_host << community.subdomain + "." if community
      community_host << community_domain
    end

    def community_domain
      community_domain = ""
      start_index = (Rails.env == 'staging') ? 0 : 1
      community_domain << request.subdomains[start_index..-1].join(".") + "." if request.subdomains.size > 1
      community_domain << request.domain + request.port_string
    end
    
    def find_community
      subdomain = subdomain_from(request)
      if subdomain.blank?
        @current_community = nil
      else
        @current_community = Community.find_by_subdomain(subdomain)
        render_404 unless @current_community
      end
    end
        
end