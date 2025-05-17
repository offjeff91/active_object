class ActiveObject
  attr_reader :data
  def initialize(data)
    @data = data
    data.each do |key, value|
      self.class.define_method(key) { value }
      if value.is_a?(Array)
        self.class.define_method("count_#{key}") { value.count }
      end
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
    else
      super(method, *args)
    end
  end
end