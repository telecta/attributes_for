[travis]: https://travis-ci.org/blacktangent/attributes_for
[codeclimate]: https://codeclimate.com/github/blacktangent/attributes_for
[coveralls]: https://coveralls.io/r/blacktangent/attributes_for
[rubygems]: https://rubygems.org/gems/attributes_for


# AttributesFor

[![Build Status](https://travis-ci.org/blacktangent/attributes_for.svg?branch=master)][travis]
[![Code Climate](https://codeclimate.com/github/blacktangent/attributes_for/badges/gpa.svg)][codeclimate]
[![Test Coverage](http://img.shields.io/coveralls/blacktangent/attributes_for/master.svg)][coveralls]
[![Gem Version](http://img.shields.io/gem/v/attributes_for.svg)][rubygems]

ActiveView Helper to present formatted ActiveModel attributes with
icons.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'attributes_for'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attributes_for

Run generator to add I18n locales:

    $ rails generate attributes_for:install

## Screenshot
![Screenshot](https://cloud.githubusercontent.com/assets/1222916/9355402/295b6324-46a3-11e5-9f8c-ff864b837cdd.png)

## Usage

Present attributes using the API in the example below. It can also generate a
standard label value pair given an attribute name using the `attribute` method. Arbitrary
strings can also be presented using the `string` method.

```erb
<ul class="list-unstyled">
  <%= attributes_for @company do |b| %>
    <li><%= b.attribute :name, class: 'fa fa-building-o' %></li>
    <li><%= b.phone :phone %></li>
    <li><%= b.phone :fax, class: 'fa fa-fax' %></li>
    <li><%= b.email :email %></li>
    <li><%= b.email :support_email %></li>
    <li><%= b.url :website, id: :site %></li>
    <li>
      <%= b.attribute(:user, class: 'fa fa-user') do %>
        <%= link_to @company.user_name, url_for(@company.user) %>
      <% end %>
    </li>
    <li><%= b.duration :duration %></li>
    <li><%= b.boolean :active %></li>
    <li><%= b.date :created_at, format: :long %> </li>
    <li>
      <%= b.string "Label" do %>
        Content
      <% end %>
    </li>
  <% end %>
</ul>
```

## Options

Available options:

* __:label__ - Disables label if set to false
* __:css__ - Override element's CSS
* __:id__ - Set element's ID

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/blacktangent/attributes_for. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

