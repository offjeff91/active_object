require 'minitest/autorun'
require_relative '../active_object'
require 'active_support/inflector'

describe ActiveObject do
  subject { ActiveObject.new(data) }

  describe 'simple root attribute' do
    book_name = "Cormen's algorithm book - 2nd edition"
    authors = [ 'Maria', 'John', 'Jeff']
    recommended_prices = [ 100.0, 80.0, 59.5, 120.0 ]
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
        describe 'direct attribute access' do
          it { assert_equal "Cormen's algorithm book - 2nd edition", subject.name }
          it { assert_equal [ 100.0, 80.0, 59.5, 120.0 ], subject.recommended_prices }
        end

        describe 'first_* method' do
          it { assert_equal 'Maria', subject.first_author }
          it { assert_raises(NoMethodError) { subject.first_name } }
        end

        describe 'last_* method' do
          it { assert_equal 'Jeff', subject.last_author }
        end

        describe '*_at method' do
          it { assert_equal 'John', subject.author_at(1) }
        end

        describe 'count_* method' do
          it { assert_equal 3, subject.count_authors }
          it { assert_equal 4, subject.count_recommended_prices }
        end

        describe 'sum_* method' do
          it { assert_equal 359.5, subject.sum_recommended_prices }
        end

        describe 'sort_* method' do
          it { assert_equal [ 59.5, 80.0, 100.0, 120.0 ], subject.sort_recommended_prices }
        end

        describe 'average_* method' do
          it { assert_equal 89.875, subject.average_recommended_price }
        end

        describe 'max_* method' do
          it { assert_equal 120.0, subject.max_recommended_price }
        end

        describe 'min_* method' do
          it { assert_equal 59.5, subject.min_recommended_price }
        end

        describe 'has_*? method' do
          it { assert subject.has_name? }
          it { refute subject.has_price? }
          it { assert_raises(NoMethodError) { subject.has_methods? } }
        end

        describe 'invalid method calls' do
          it { assert_raises(NoMethodError) { subject.test_author } }
        end
      end
    end
  end
end

