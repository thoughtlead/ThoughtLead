module SubdomainHelper
  
  def subdomain_from(request)
    request.subdomains.first.to_s
  end
  
end
