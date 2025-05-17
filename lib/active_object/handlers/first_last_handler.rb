module ActiveObject
  module Handlers
    class FirstLastHandler
      def self.handles?(method)
        method =~ /^(first|last)_(.+)$/
      end

      def self.handle!(method, *args, caller, &default)
        method =~ /^(first|last)_(.+)$/
        operation = $1
        attribute = $2
        if caller[attribute.pluralize].is_a?(Array)
          array = caller.data[attribute.pluralize.to_sym] || caller.data[attribute.pluralize.to_s]
          array.send(operation)
        else
          yield
        end
      end
    end
  end
end 