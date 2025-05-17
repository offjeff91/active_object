require 'active_support/inflector'

require 'active_object/handler'
require 'active_object/handlers/has_handler'
require 'active_object/handlers/first_last_handler'
require 'active_object/handlers/average_handler'
require 'active_object/handlers/min_max_handler'
require 'active_object/handlers/at_handler'
require 'active_object/handlers/array_handler'

class ActiveObject
  attr_reader :data

  def initialize(data)
    @data = data
    data.each do |key, value|
      self.class.define_method(key) { value }
      self.class.define_method("has_#{key}?") { true }
    end
  end

  def method_missing(method, *args)
    default = -> { super(method, *args) }
    Handler.handle!(method, *args, self, &default)
  end

  def [](attribute)
    data[attribute.to_sym] || data[attribute.to_s]
  end
end 