module SubdomainHelper

  def subdomain_from(request)
    return '' if (RAILS_ENV == 'production') && (request.subdomains == ["thoughtlead", "verticality", "dock"])
    request.subdomains.first.to_s
  end

end
