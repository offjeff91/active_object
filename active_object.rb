class ActiveObject
  attr_reader :data
  def initialize(data)
    @data = data
    data.each do |key, value|
      self.class.define_method(key) { value }
    end
  end
  def method_missing(method)
    if method =~ /^has_(.+)\?$/
      data.key?($1.to_sym)
    else
      super(method)
    end
  end
end