[![Code Climate](https://codeclimate.com/github/appdrones/page_record.png)](https://codeclimate.com/github/appdrones/page_record) [![Build Status](https://travis-ci.org/appdrones/page_record.png)](https://travis-ci.org/appdrones/page_record) [![Dependency Status](https://gemnasium.com/appdrones/page_record.png)](https://gemnasium.com/appdrones/page_record) [![Coverage Status](https://coveralls.io/repos/appdrones/page_record/badge.png)](https://coveralls.io/r/appdrones/page_record)

# PageRecord

You've probably been there. You're building your killer Web Application. You, being a responsible developer, your code is thoroughly tested. You are using the likes of cucumber and Rspec to do so. Besides your unit-tests, you also have integration tests doing a full stack test. You are using Capybara to read, parse and test the rendered pages. You use all kinds of selectors to select different parts of the page. Slowly but surely your test code becomes less and less readable.

## PageRecord can help.
There are a lot of ways you can do this. PageRecord is one of these ways. PageRecord is an ActiveRecord like abstraction for information on the HTML page. You can use `TeamRecord.find(1)` and `TeamRecord.find_by_name('Barcelona')` like functions to find a record on an HTML page. When you've found the record you need, you can use easy accessors to access the attributes. `TeamRecord.find(1).name` returns the name of the team.

TODO explain how it helps in testing

##Documentation
Look at [the yard documentation](http://rubydoc.info/github/appdrones/page_record/PageRecord) for details. Check [Changes](https://github.com/appdrones/page_record/blob/master/CHANGES.md) for (breaking) changes per version.

##Markup
For [PageRecord](http://rubydoc.info/github/appdrones/page_record/PageRecord) to recognise the data on the page, the page __must__ follow certain `html` formatting guidelines.

__Every__ record on the page __must__ have a `data-type-id='x'` attribute. 

```html
<tag data-type-id='x'>
...
<tag>
```
Where `1` is the `id` of the record and `type` is the type of record. See [PageRecord::Base.type](http://rubydoc.info/github/appdrones/page_record/PageRecord/Base#type-class_method) for information regarding the `type`.

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
With [PageRecord](http://rubydoc.info/github/appdrones/page_record/PageRecord), you can easily access the attributes of a record on the page. After you've got a valid instance of [PageRecord::Base](http://rubydoc.info/github/appdrones/page_record/PageRecord/Base), you can access all attributes in a normal ruby-like way.

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
When you define you page class as a subclass of [PageRecord::Base](http://rubydoc.info/github/appdrones/page_record/PageRecord/Base), it automagicaly looks for a host class. To get the name of your host class, PageRecord removes the `Page` part of you class name and tries to use that class as a host class.

Example:

```ruby
class TeamPage < PageRecord::Base
end
```

will result in a host class of `Team`

####what is the host class
The host class is a class who's attributes are mirrored by PageRecord. At this point in time PageRecord only has support for `ActiveRecord` host classes. To be more specific: To be used as a host class, the class must support the method `attribute_names` to return an [Array](http://ruby-doc.org/core-2.0/Array.html) of [String](http://ruby-doc.org/core-2.0/String.html) of [Symbol](http://ruby-doc.org/core-2.0/Symbol.html).

Example:

Given the following host class and PageRecord class

```ruby
class Team < ActiveRecord::Base
# The database defines the following records
# name, position, points
#
end

class TeamPage < PageRecord::Base
end
```

Then a record from the TeamPage responds to the attributes: `name`, `position`, `points`

####what is the host class
If you want to use a totaly different class name, you can use the `host_class` macro to specify what should be the host class.

Example:

```ruby
class JustSomeClass
  host_class Team
end
```

This creates class `JustSomeClass` with the same capabilities as the `TeamPage` class in the previous example.

###Adding some attributes
If you have a full_name on a page that isn't available in the host_class, you can add that attribute.

```ruby
class TeamPage < PageRecord::Base
  add_attributes ['full_name']
end
```

###Setting all attributes
Sometimes it is easier to not have a host class, but just set the attributes your self. You can do this withe the attributes macro.

```ruby
class JustSomePage < PageRecord::Base
  attributes ['first_name', 'last_name', 'full_name']
end
```


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

Sometimes you don't want to click the element. PageRecord supports this by calling the action routine with a `?`. This returns the [Capybara Result](http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Result). You can do with this element whatever you can do with this element what you want.

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
To use [PageRecord](http://rubydoc.info/github/appdrones/page_record/PageRecord) with Rspec, you need to require it in your `spec_helper.rb` file. To make it work, it needs to be required __after__ capybara.

```ruby
require 'capybara'
require 'page_record/rspec'
```

Also, you need te make sure your page definitions are included. A good place to store them would be in your support directory.

##Using PageRecord together with Cucumber
To use [PageRecord](http://rubydoc.info/github/appdrones/page_record/PageRecord) with Cucumber, you need to require it in your `env.rb` file. To make it work, it needs to be required __after__ capybara.

```ruby
require 'capybara'
require 'page_record/cucumber'
```
Also, you need te make sure your page definitions are included. A good place to store them would be in your support directory.

##Using PageRecord standalone
If you are using [PageRecord](http://rubydoc.info/github/appdrones/page_record/PageRecord) outside of Rspec or Cucumber, you also need to require the right files.

```ruby
require 'capybara'
require 'page_record/rspec'
```

You also need te make sure, you set the page variable before you start.

```ruby
PageRecord::Base.page = session
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
