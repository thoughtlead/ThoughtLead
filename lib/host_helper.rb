module HostHelper
  
  def host_from(request)
    host = request.domain
    host = (request.subdomains * ".") + "." + host unless request.subdomains.blank?
    
    return host
  end
  
end
