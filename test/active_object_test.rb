require 'minitest/autorun'
require_relative '../active_object'

describe ActiveObject do
  subject { ActiveObject.new(data) }

  describe 'simple root attribute' do
    let(:data) { { name: "Cormen's algorithm book - 2nd edition" } }

    it { assert_equal "Cormen's algorithm book - 2nd edition", subject.name }
    it { assert subject.has_name? }
  end
end

