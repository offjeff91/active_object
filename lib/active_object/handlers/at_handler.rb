module ActiveObject
  module Handlers
    class AtHandler
      def self.handles?(method)
        method =~ /^(.+)_(at)$/
      end

      def self.handle!(method, *args, caller)
        method =~ /^(.+)_(at)$/
        attribute = $1
        if caller[attribute.pluralize].is_a?(Array)
          caller[attribute.pluralize][args.first.to_i]
        else
          yield
        end
      end
    end
  end
end 