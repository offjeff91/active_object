module ActiveObject
  module Handlers
    class HasHandler
      def self.handles?(method)
        method =~ /^has_(.+)\?$/
      end

      def self.handle!(method, *args, _caller, &block)
        method =~ /^has_(.+)\?$/
        suffix = $1
        if self.respond_to?(suffix.to_sym)
          block.call
        else
          false
        end
      end
    end
  end
end 