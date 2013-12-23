# TabooReactiveSearch

    Taboo reactive search to solve travelling salesman.

## Installation

Add this line to your application's Gemfile:

    gem 'taboo_reactive_search'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install taboo_reactive_search

## Usage

    TabooReactiveSearch::TabooReactiveSearch.new.search([[565,575],[25,185]], 50, 100, 1.3, 0.9)[:cost]

    50 - max candidates
    100 - max iterations
    1.3 - increase
    0.9 - drop

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
