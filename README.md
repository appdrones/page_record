[![Code Climate](https://codeclimate.com/github/appdrones/page_record.png)](https://codeclimate.com/github/appdrones/page_record) [![Build Status](https://travis-ci.org/appdrones/page_record.png)](https://travis-ci.org/appdrones/page_record) [![Dependency Status](https://gemnasium.com/appdrones/page_record.png)](https://gemnasium.com/appdrones/page_record) [![Coverage Status](https://coveralls.io/repos/appdrones/page_record/badge.png)](https://coveralls.io/r/appdrones/page_record)

# PageRecord

You've probably been there. You're building your killer Web Application. You, being a responsible developer, your code is thoroughly tested. You are using the likes of cucumber and Rspec to do so. Besides your unit-tests, you also have integration tests doing a full stack test. You are using Capybara to read, parse and test the rendered pages. You use all kinds of selectors to select different parts of the page. Slowly but surely your test code becomes less and less readable.

## PageRecord can help.
There are a lot of ways you can do this. PageRecord is one of these ways. PageRecord is an ActiveRecord like abstraction for information on the HTML page. You can use `TeamRecord.find(1)` and `TeamRecord.find_by_name('Barcelona')` like functions to find a record on an HTML page. When you've found the record you need, you can use easy accessors to access the attributes. `TeamRecord.find(1).name` returns the name of the team.


TODO explain how it helps in testing

## Installation

Add this line to your application's Gemfile:

    gem 'page_record'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install page_record

## Usage

TODO exmplain how to use it

## Example

TODO show an example

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
