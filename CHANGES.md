#Changes

##V1.0.3
* Added support for getting the Capybara element of a record.
* #id now returns an integer 

##V1.0.2
* Added the id of the record to the inspector.
* inspecting uses the Array variant of Capybara and doesn't wait. 

##V1.0.1
* Fixed a bug in action handling that causes page actions aoutside of a record te be noticed. Refactored the action handling.

##V1.0.0
Released to production

##V0.5.0
* Added a rails project containing some cucumber features to demonstrate how it works. The example also shows how to use the rails and Formtastic helpers.
* Added support for form validations. Both in formtastic and in reading the errors
* added a `inspect` for both the class and for the instances. This is __very__ helpfull when dubugging.

##V0.4.0
* Added support for Formtasic
* Added spec's for rails helpers

##V0.3.0
* Added rails helpers to make it easy in rails to have a form, recognised by PageRecord
* Added other helpers to mke it easy to add `actions` and `attribute` tags

##V0.2.1
* Fixed a bug. PageRecord stack dumped when the class contained the name `Page` 

##V0.2.0
* __BREAKING CHANGE__ Changed class name `PageRecord::PageRecord` to `PageRecord::Base`. Just a rename should be enough.
* Added `add_attributes` class method. This allows you to just add extra attributes instead of specifying them all
* Added `host_class` class method. Now you are able to set any class as a host class instead of beeing glued to xxxxPage`



