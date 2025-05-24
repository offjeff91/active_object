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
    Handler.handle!(method, *args, self) { super(method, *args) }
  end

  def respond_to?(method)
    return true if super(method)

    Handler.handles?(method)
  end

  def [](attribute)
    data[attribute.to_sym] || data[attribute.to_s]
  end
end

HasHandler = Class.new do
  def self.handles?(method)
    method =~ /^has_(.+)\?$/
  end

  def self.handle!(method, *_args, _caller)
    method =~ /^has_(.+)\?$/
    suffix = Regexp.last_match(1)
    if respond_to?(suffix.to_sym)
      yield
    else
      false
    end
  end
end
FirstLastHandler = Class.new do
  def self.handles?(method)
    method =~ /^(first|last)_(.+)$/
  end

  def self.handle!(method, *_args, caller)
    method =~ /^(first|last)_(.+)$/
    operation = Regexp.last_match(1)
    attribute = Regexp.last_match(2)
    if caller[attribute.pluralize].is_a?(Array)
      array = caller.data[attribute.pluralize.to_sym] || caller.data[attribute.pluralize.to_s]
      array.send(operation)
    else
      yield
    end
  end
end
AverageHandler = Class.new do
  def self.handles?(method)
    method =~ /^(average)_(.+)$/
  end

  def self.handle!(method, *_args, caller)
    method =~ /^(average)_(.+)$/
    attribute = Regexp.last_match(2)
    if caller[attribute.pluralize].is_a?(Array)
      array = caller[attribute.pluralize]
      array.sum * 1.0 / array.count
    else
      yield
    end
  end
end
MinMaxHandler = Class.new do
  def self.handles?(method)
    method =~ /^(max|min)_(.+)$/
  end

  def self.handle!(method, *_args, caller)
    method =~ /^(max|min)_(.+)$/
    operation = Regexp.last_match(1)
    attribute = Regexp.last_match(2)
    if caller[attribute.pluralize].is_a?(Array)
      array = caller[attribute.pluralize]
      array.send(operation)
    else
      yield
    end
  end
end
AtHandler = Class.new do
  def self.handles?(method)
    method =~ /^(.+)_(at)$/
  end

  def self.handle!(method, *args, caller)
    method =~ /^(.+)_(at)$/
    attribute = Regexp.last_match(1)
    if caller[attribute.pluralize].is_a?(Array)
      caller[attribute.pluralize][args.first.to_i]
    else
      yield
    end
  end
end
ArrayHandler = Class.new do
  def self.handles?(method)
    method =~ /^(sum|sort|count)_(.+)$/
  end

  def self.handle!(method, *_args, caller)
    method =~ /^(sum|sort|count)_(.+)$/
    operation = Regexp.last_match(1)
    attribute = Regexp.last_match(2)
    value = caller[attribute]
    if value.is_a?(Array) && value.respond_to?(operation)
      value.send(operation)
    else
      yield
    end
  end
end

class Handler
  HANDLERS = [
    HasHandler,
    FirstLastHandler,
    AverageHandler,
    MinMaxHandler,
    AtHandler,
    ArrayHandler
  ].freeze

  def self.handle!(method, *args, caller, &default)
    handler = HANDLERS.find { |handler| handler.handles?(method) }
    if handler.nil?
      default.call
    else
      handler.handle!(method, *args, caller, &default)
    end
  end

  def self.handles?(method)
    HANDLERS.any? { |handler| handler.handles?(method) }
  end
end
