module ActiveRecord
  class Base
    before_save(:_clean_whitespace)
    
    def _clean_whitespace
      self.attributes.each_pair do |key, value|
        RAILS_DEFAULT_LOGGER.debug("stripping #{key.to_s} wih value #{value.to_s}")
        self[key] = value.strip if value.respond_to?('strip')
      end
    end
  end
end


