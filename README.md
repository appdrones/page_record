[![Code Climate](https://codeclimate.com/github/appdrones/page_record.png)](https://codeclimate.com/github/appdrones/page_record) [![Build Status](https://travis-ci.org/appdrones/page_record.png)](https://travis-ci.org/appdrones/page_record) [![Dependency Status](https://gemnasium.com/appdrones/page_record.png)](https://gemnasium.com/appdrones/page_record) [![Coverage Status](https://coveralls.io/repos/appdrones/page_record/badge.png)](https://coveralls.io/r/appdrones/page_record)

# PageRecord

You've probably been there. You're building your killer Web Application. You, being a responsible developer, your code is thoroughly tested. You are using the likes of cucumber and Rspec to do so. Besides your unit-tests, you also have integration tests doing a full stack test. You are using Capybara to read, parse and test the rendered pages. You use all kinds of selectors to select different parts of the page. Slowly but surely your test code becomes less and less readable.

## PageRecord can help.
There are a lot of ways you can do this. PageRecord is one of these ways. PageRecord is an ActiveRecord like abstraction for information on the HTML page. You can use `TeamRecord.find(1)` and `TeamRecord.find_by_name('Barcelona')` like functions to find a record on an HTML page. When you've found the record you need, you can use easy accessors to access the attributes. `TeamRecord.find(1).name` returns the name of the team.

TODO explain how it helps in testing

##Documentation
Look at {http://rubydoc.info/github/appdrones/page_record the yard documentation} for details.

##Markup
For {PageRecord} to recognise the data on the page, the page __must__ follow certain `html` formatting guidelines.

__Every__ record on the page __must__ have a `data-type-id='x'` attribute. 

```html
<tag data-type-id='x'>
...
<tag>
```
Where `1` is the `id` of the record and `type` is the type of record. See {PageRecord::PageRecord.type} for infrmation regarding the `type`.

__Every__ attribute of a record, __must__ have a `data-attribute-for='name'` attribute. This tag __must__ be contained inside a tag contaning the `data-type-id='x'` 

```html
<tag data-team-id='1'>
  <tag data-attribute-for='attr'>Ajax</tag>
...
<tag>
```

Where `attr` is the name of the attribute.

##attributes

###reading the attributes
With {PageRecord}, you can easily access the attributes of a record on the page. After you've got a valid instance of {PageRecord::PageRecord}, you can access all attributes in a normal ruby-like way.

```ruby
  champion = TeamPage.find(1)
  expect(champion.name).to eq('Ajax')
```
###setting the attributes
Not only can you access the attributes for reading, you can also set the attributes. This only works if the attribute is modifiable, like in an `INPUT` or a `TEXTFIELD` tag.

```ruby
  champion = TeamPage.find(1)
  champion.name = 'Ajax'
```

###specifying the attributes
When you define you page class as a subclass of {PageRecord::PageRecord}, it automagicaly looks for a host class. To get the name of your host class, PageRecord removes the `Page` part of you class name and tries to use that class as a host class.

Example:

```ruby
class TeamPage < PageRecord::PageRecord
end
```

will result in a host class of `Team`

####what is the host class
The host class is a class who's attributes are mirrored by PageRecord. At this point in time PageRecord only has support for `ActiveRecord` host classes. To be more specific: To be used as a host class, the class must support the method `attribute_names` to return an {::Array} of {::String} of {::Symbol}.

Example:

Given the following host class and PageRecord class

```ruby
class Team < ActiveRecord::Base
# The database defines the following records
# name, position, points
#
end

class TeamPage < PageRecord::PageRecord
end
```

Then a record from the TeamPage responds to the attributes: `name`, `position`, `points`

##actions
PageRecord support record actions and page actions. 

###record actions
A record action is an action that is found within a `data-type-id=` tag. To define an action, you can use the `data-action-for='create'` tag.

An example:

```html
<form data-team-id='1'>
  Name: <input data-attribute-for='name'>
  Position: <input data-attribute-for='position'>
  <button data-action-for='save'>Create</button>
</form>
```

with this markup on your page, you can use the following ruby code:

```ruby
team = TeamPage.find(1)
team.name = 'Ajax'
team.position = 1
team.save
```

When you call an action method, PageRecord automagicaly clicks the specified HTML element.

Sometimes you don't want to click the element. PageRecord supports this by calling the action routine with a `?`. This returns the {http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Result Capybara Result}. You can do with this element whatever you can do with this element what you want.

```ruby
TeamPage.save?
```

###page actions
Sometimes you need to have an action that is not related to a record. An example is the creation of a new record. But in fact, any `data-action-for` tag, outside of a record, can be called as a page action.

An example:

```html
<form data-team-id='1'>
  Name: <input data-attribute-for='name'>
  Position: <input data-attribute-for='position'>
  <button data-action-for='save'>
</form>
<button data-action-for='create'>New Team</button>
```

```ruby
TeamPage.create
```

When you call an action method, PageRecord automagicaly clicks the specfied HTML element.

Sometimes you don't want to click the element. PageRecord supports this by calling the action routine with a `?`. This returns the Capybara Element. You can do with this element whatever you can do with this element what you want.

```ruby
TeamPage.save?
```

##Using PageRecord together with Rspec
To use {PageRecord} with Rspec, you need to require it in your `spec_helper.rb` file. To make it work, it needs to be required __after__ capybara.

```ruby
require 'capybara'
require 'page_record/rspec'
```

Also, you need te make sure your page definitions are included. A good place to store them would be in your support directory.

##Using PageRecord together with Cucumber
To use {PageRecord} with Cucumber, you need to require it in your `env.rb` file. To make it work, it needs to be required __after__ capybara.

```ruby
require 'capybara'
require 'page_record/cucumber'
```
Also, you need te make sure your page definitions are included. A good place to store them would be in your support directory.

##Using PageRecord standalone
If you are using {PageRecord} outside of Rspec or Cucumber, you also need to require the right files.

```ruby
require 'capybara'
require 'page_record/rspec'
```

You also need te make sure, you set the page variable before you start.

```ruby
PageRecord::PageRecord.page = session
```

Also, you need te make sure your page definitions are included. 


## Installation

Add this line to your application's Gemfile:

    gem 'page_record', :require => false

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install page_record

## Usage

TODO explain how to use it

## Example

TODO show an example

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
