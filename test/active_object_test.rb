require 'minitest/autorun'
require_relative '../active_object'

describe ActiveObject do
  subject { ActiveObject.new(data) }

  describe 'simple root attribute' do
    book_name = "Cormen's algorithm book - 2nd edition"
    cases = {
      "with hash key" => { name: book_name },
      "with string key" => { "name" => book_name }
    }
    cases.each do |description, param|
      let(:data) { param }
      describe description do
        it { assert_equal book_name, subject.name }
        it { assert subject.has_name? }
        it { refute subject.has_price? }
        it { assert_raises(NoMethodError) { subject.has_methods? } }
      end
    end
  end
end

