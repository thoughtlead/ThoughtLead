module SubdomainHelper

  def subdomain_from(request)
    return '' if (Rails.env == 'staging') && (request.subdomains == ["thoughtlead", "verticality", "dock"])
    request.subdomains.first.to_s
  end

end
