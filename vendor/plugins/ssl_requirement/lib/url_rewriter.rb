require 'action_controller/url_rewriter'
require 'action_controller/routing/optimisations'

module ActionController
  class UrlRewriter
    # Add a secure option to the rewrite method.
    def rewrite_with_secure_option(options = {})
      secure = options.delete(:secure)
      options.merge!(:only_path => false, :protocol => secure ? 'https' : 'http') unless SslRequirement.disable_ssl_check?
      rewrite_without_secure_option options
    end
    alias_method_chain :rewrite, :secure_option
  end

  module Routing
    module Optimisation
      class PositionalArgumentsWithAdditionalParams
        def guard_conditions_with_secure_option
          guard_conditions_without_secure_option + ['!args.last.has_key?(:secure)']
        end
        alias_method_chain :guard_conditions, :secure_option
      end
    end
  end
end
