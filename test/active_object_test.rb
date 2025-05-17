require 'minitest/autorun'
require_relative '../active_object'

describe ActiveObject do
  subject { ActiveObject.new(data) }

  describe 'simple root attribute' do
    book_name = "Cormen's algorithm book - 2nd edition"
    authors = [ 'Maria', 'John', 'Jeff']
    recommended_prices = [ 99.99, 79.99, 59.99, 119.99 ]
    cases = {
      "with hash key" => { 
        name: book_name, 
        authors: authors,
        recommended_prices: recommended_prices
      },
      "with string key" => { 
        "name" => book_name, 
        "authors" => authors,
        "recommended_prices" => recommended_prices
      }
    }
    cases.each do |description, param|
      let(:data) { param }
      describe description do
        it { assert_equal book_name, subject.name }
        it { assert_equal authors, subject.authors }
        it { assert_equal recommended_prices, subject.recommended_prices }
        it { assert_equal 3, subject.count_authors }
        it { assert_equal 4, subject.count_recommended_prices }
        it { assert subject.has_name? }
        it { refute subject.has_price? }
        it { assert_raises(NoMethodError) { subject.has_methods? } }
      end
    end
  end
end

