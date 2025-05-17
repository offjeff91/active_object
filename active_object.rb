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
  HasHandler = Class.new do
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
  FirstLastHandler = Class.new do
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
  AverageHandler = Class.new do
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
  MinMaxHandler = Class.new do
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
  AtHandler = Class.new do
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
  ArrayHandler = Class.new do
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

  Handler = Class.new do
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
  end
end