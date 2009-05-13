module HostHelper
  
  def host_from(request)
    host = request.host
    if $host_suffix
      # If the host exactly matches the suffix, return blank
      logger.info "#{host} == #{$host_suffix}?"
      return nil if host == $host_suffix
      
      host = host.gsub(".#{$host_suffix}",'')
    end
    return host
  end
  
end
