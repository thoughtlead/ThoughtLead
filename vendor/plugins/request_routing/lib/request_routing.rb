module ActionController
  module Routing
    class Route
      
      TESTABLE_REQUEST_METHODS = [:is_client_domain, :domain, :method, :port, :remote_ip, 
      :content_type, :accepts, :request_uri, :protocol]
      
      def recognition_conditions
        result = ["(match = #{Regexp.new(recognition_pattern).inspect}.match(path))"]
        conditions.each do |method, value|
          if TESTABLE_REQUEST_METHODS.include? method
            result << if value.is_a? Regexp
              "conditions[#{method.inspect}] =~ env[#{method.inspect}]"
            else
              "conditions[#{method.inspect}] === env[#{method.inspect}]"
            end
          else
          end
        end
        result
      end
      
    end
    
    class RouteSet
      def extract_request_environment(request)        
        { 
          :is_client_domain => request.host != $app_host,
          :method => request.method,
          :domain => request.domain, 
          :port => request.port, 
          :remote_ip => request.remote_ip, 
          :content_type => request.content_type, 
          :accepts => request.accepts.map(&:to_s).join(','), 
          :request_uri => request.request_uri, 
          :protocol => request.protocol
        }
      end
    end
  end
end