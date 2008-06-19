module SubdomainHelper
  
  def subdomain_from(request)
    return '' if request.host == APP_DOMAIN
    request.subdomains.first.to_s
  end
  
end
