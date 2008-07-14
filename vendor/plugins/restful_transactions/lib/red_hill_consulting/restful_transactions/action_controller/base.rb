module RedHillConsulting::RestfulTransactions::ActionController
  module Base
    def self.included(base)
      base.prepend_around_filter(TransactionFilter)
    end
  end
  
  class TransactionFilter
    def self.filter(controller)
      case controller.request.method
      when :post, :put, :delete then
        ActiveRecord::Base.transaction { |*block_args| yield(*block_args) if block_given? }
      else
        yield if block_given?
      end
    end
  end
end
