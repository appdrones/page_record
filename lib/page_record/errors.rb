module PageRecord


	##
	# This {::Exception} is raised when the specified record is not found 
	# on the page. Check your selector, filter and HTML code for details.
	#
	# ```html
	# <div data-team-id='10'>
	# 	<div data-attribute-for='name'>Ajax</div>
	# </div>
	# ```
	# When the following code is executed, the {RecordNotFound} exception is raised.
	#
	# ```ruby
	# TeamPage.find(11)
	#```
	#
	class RecordNotFound < Exception
	end

	##
	# This {::Exception} is raised when the specfied attribute is not found
	# on the page. Check your selector, filter and HTML code for details.
	#
	# ```html
	# <div data-team-id='10'>
	# 	<div data-attribute-for='name'>Ajax</div>
	# </div>
	# ```
	# When the following code is executed, the {AttributeNotFound} exception is raised.
	#
	# ```ruby
	# TeamPage.find(10).ranking
	#```
	#
	class AttributeNotFound < Exception
	end

	##
	# This {::Exception} is raised when you have not set the page variable
	# of the class. Check {PageRecord::PageRecord.page} for details
	#
	class PageNotSet < Exception
	end

	##
	# This {::Exception} is raised when the page contains multiple instances 
	# of the specfied record type. Use a selector to narrow the search.
	#
	# ```html
	# <div id='first-table' data-team-id='10'>
	# 	<div data-attribute-for='name'>Ajax</div>
	# </div>
	# <div id='second-table' data-team-id='10'>
	# 	<div data-attribute-for='name'>Ajax</div>
	# </div>
	# ```
	# When the following code is executed, the {MultipleRecords} exception is raised.
	#
	# ```ruby
	# TeamPage.find(10)
	#```
	#
	# To fix this, use the `#first-table` in the selector
	#
	# ```ruby
	# TeamPage.find(10, '#first-table')
	#```
	#
	class MultipleRecords < Exception
	end

	# This {::Exception} is raised when you try to set a non input field.
	#
	# ```ruby
	# <div data-team-id=1>
	# 	<div data-attribute-for='name'>PSV</div>
	# </div>
	# ```
	# When the following code is executed, the {NotInputField} exception is raised.
	#
	# ```ruby
	# team_on_page.name = 'Ajax'  
	# ```
	class NotInputField < Exception
	end
end