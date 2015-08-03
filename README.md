# AttributesFor

Easily present formatted ActiveModel attributes with translated label and an optional icon.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'attributes_for'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attributes_for

## Usage

Present the attributes using the API in the example below. It can also generate a
standard label value pair given an attribute name using the `attr` method. Arbitrary
strings can also be presented using the `string` method.

```ruby
<%= attributes_for(@company) do |b| %>
  <%= b.phone :phone %>
  <%= b.email :email %>
  <%= b.url :website %>
  <%= b.date :created_at %>
  <%= b.attribute :credit_rating %>
  <%= b.string "A string" %>
<% end %>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/blacktangent/attributes_for. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

