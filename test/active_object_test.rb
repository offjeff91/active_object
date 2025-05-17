require 'minitest/autorun'
require_relative '../active_object'

describe ActiveObject do
  it { assert_equal 42, ActiveObject.new.code }
end

