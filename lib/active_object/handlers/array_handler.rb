module ActiveObject
  module Handlers
    class ArrayHandler
      def self.handles?(method)
        method =~ /^([a-z]+)_(.+)$/
      end

      def self.handle!(method, *args, caller)
        method =~ /^([a-z]+)_(.+)$/
        operation = $1
        attribute = $2
        value = caller[attribute]
        if value.is_a?(Array) && value.respond_to?(operation)
          value.send(operation)
        else
          yield
        end
      end
    end
  end
end 