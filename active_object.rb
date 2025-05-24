class ActiveObject
  require 'active_support/inflector'
  attr_reader :data

  def initialize(data)
    @data = data
    data.each do |key, value|
      self.class.define_method(key) { value }
      if value.is_a?(Array)
        self.class.define_method("first_#{key.singularize}") { value.first }
        self.class.define_method("last_#{key.singularize}") { value.last }
        self.class.define_method("average_#{key.singularize}") { value.sum * 1.0 / value.count }
        self.class.define_method("min_#{key.singularize}") { value.min }
        self.class.define_method("max_#{key.singularize}") { value.max }
        self.class.define_method("#{key.singularize}_at") { |index| value[index] }
        self.class.define_method("sum_#{key}") { value.sum }
        self.class.define_method("sort_#{key}") { value.sort }
        self.class.define_method("count_#{key}") { value.count }
      end
    end
  end
end