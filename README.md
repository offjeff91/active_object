# ActiveObject

A Ruby library that provides dynamic method generation and array operations for hash-like objects.

## Features

- Dynamic method generation for hash keys
- Array operations for array values:
  - `first_*` - Get first element
  - `last_*` - Get last element
  - `average_*` - Calculate average
  - `min_*` - Find minimum value
  - `max_*` - Find maximum value
  - `*_at` - Access element by index
  - `sum_*` - Calculate sum
  - `sort_*` - Sort array
  - `count_*` - Count elements

## Usage

```ruby
require 'active_object'
require 'active_support/inflector'

# Create an ActiveObject with hash data
data = {
  name: "Cormen's algorithm book - 2nd edition",
  authors: ['Maria', 'John', 'Jeff'],
  recommended_prices: [100.0, 80.0, 59.5, 120.0]
}

book = ActiveObject.new(data)

# Access attributes directly
book.name                    # => "Cormen's algorithm book - 2nd edition"
book.authors                 # => ['Maria', 'John', 'Jeff']

# Array operations
book.first_author           # => "Maria"
book.last_author            # => "Jeff"
book.author_at(1)           # => "John"
book.count_authors          # => 3
book.sum_recommended_prices # => 359.5
book.sort_recommended_prices # => [59.5, 80.0, 100.0, 120.0]
book.average_recommended_price # => 89.875
book.max_recommended_price  # => 120.0
book.min_recommended_price  # => 59.5
```

## Requirements

- Ruby
- ActiveSupport (for string inflection)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_object'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install active_object
``` 