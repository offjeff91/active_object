class ActiveObject
  attr_reader :data
  def initialize(data)
    @data = data
    data.each do |key, value|
      self.class.define_method(key) { value }
    end
  end
  def method_missing(method, *args)
    if method =~ /^has_(.+)\?$/
      suffix = $1
      if data.key?(suffix.to_sym) || data.key?(suffix.to_s)
        true
      elsif self.respond_to?(suffix.to_sym)
        super(method, *args)
      else
        false
      end
    elsif method =~ /^([a-z]+)_(.+)$/
      operation = $1
      attribute = $2
      value = data[attribute.to_sym] || data[attribute.to_s]
      if value.is_a?(Array) && value.respond_to?(operation)
        value.send(operation)
      else
        super(method, *args)
      end
    else
      super(method, *args)
    end
  end
end