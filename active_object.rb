class ActiveObject
  attr_reader :data
  def initialize(data)
    @data = data
    data.each do |key, value|
      self.class.define_method(key) { value }
      self.class.define_method("has_#{key}?") { true }
    end
  end
end