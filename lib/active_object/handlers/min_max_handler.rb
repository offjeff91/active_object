module ActiveObject
  module Handlers
    class MinMaxHandler
      def self.handles?(method)
        method =~ /^(max|min)_(.+)$/
      end

      def self.handle!(method, *args, caller)
        method =~ /^(max|min)_(.+)$/
        operation = $1
        attribute = $2
        if caller[attribute.pluralize].is_a?(Array)
          array = caller[attribute.pluralize]
          array.send(operation)
        else
          yield
        end
      end
    end
  end
end 