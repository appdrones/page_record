#Changes

##V0.2.0
* __BREAKING CHANGE__ Changed class name `PageRecord::PageRecord` to `PageRecord::Base`. Just a rename should be enough.
* Added `add_attributes` class method. This allows you to just add extra attributes instead of specifying them all
* Added `host_class` class method. Now you are able to set any class as a host class instead of beeing glued to xxxxPage`

##V0.2.1
* Fixed a bug. PageRecord stack dumped when the class contained the name `Page` 


##V0.3.0
* Fixed a bug. PageRecord stack dumped when the class contained the name `Page` 
* Added rails helpers to make it easy in rails to have a form, recognised by PageRecord
* Added other helpers to mke it easy to add `actions` and `attribute` tags