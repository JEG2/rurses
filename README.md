# Rurses

Rurses (pronounced like [Scooby-Doo](http://en.wikipedia.org/wiki/Scooby-Doo_%28character%29) saying "Curses") is meant to be a more Ruby-like interface to ncurses.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rurses'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rurses

## Usage

```ruby
Rurses.program(modes: %i[c_break no_echo keypad]) do |screen|
  screen.draw_string("Enter a key:  ")

  key = Rurses.get_key

  screen.move_cursor(x: 0, y: 1)
  screen.style(:bold) do
    screen.draw_string("You typed %p." % key)
  end

  screen.refresh_in_memory
  Rurses.update_screen
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rurses/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
