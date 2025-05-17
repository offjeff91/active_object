module ActiveObject
  module Handlers
    class AverageHandler
      def self.handles?(method)
        method =~ /^(average)_(.+)$/
      end

      def self.handle!(method, *args, caller)
        method =~ /^(average)_(.+)$/
        attribute = $2
        if caller[attribute.pluralize].is_a?(Array)
          array = caller[attribute.pluralize]
          array.sum * 1.0 / array.count
        else
          yield
        end
      end
    end
  end
end 