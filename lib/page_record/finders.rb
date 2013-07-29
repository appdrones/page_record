module PageRecord
  ##
  # PageRecord is  a specific sort of {http://assertselenium.com/automation-design-practices/page-object-pattern/ PageObject pattern}. Where a "normal"
  # {http://assertselenium.com/automation-design-practices/page-object-pattern/ PageObject} tries to make the page accessible with business like functions.
  # We have taken a different approach. We've noticed that a lot of WebPage are
  # mainly luxury CRUD pages. This means that almost every page shows one or more
  # records of a certain type and has the ability to create, read update and delete
  # one or more records. Sounds familiar? Yes,  it is the same as an ActiveRecord
  # pattern. So we tried to make accessing a page as close as possible to accessing
  # an ActiveRecord.
  #
  # To make this work, however, we need to add extra information to the HTML page.
  # With HTML5, , you can do this easily. HTML-5 supports the data- attributes on any
  # tag. We use these tags to identify the records on the page.
  #
  #
  module Finders

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      ##
      #
      # Searches the page and returns an {::Array} of {PageRecord::Base} of instances of
      # that match the selector and the filter. See {file:README.md#markup markup} for more
      # details about formatting the page.
      #
      # example:
      #
      # ```ruby
      # TeamPage.all
      # ```
      #
      # returns all records on the page
      #
      # @param	selector 	[String] selector to use for searching the table on the page
      # @param	filter		[String] filter to use on the records on the page
      #
      # @return	[Array Pagerecord]	The Array containing instances of [PageRecord::Base]
      #  								with records that fit the selector and the filter
      #
      # @raise	[MultipleRecords]	if the page contains more then on set of records
      # @raise 	[RecordNotFound]	if the page does not contain any of the specified records
      #
      def all(selector = nil, filter = nil)
        selector ||= @selector
        filter ||= @filter
        records = []
        context = context_for_selector(selector)
        context.all("[data-#{@type}-id]#{filter}").each do | record|
          id = record["data-#{@type}-id"]
          records << new(id, selector)
        end
        records
      end

      ##
      #
      # Searches the page and returns an instance of {PageRecord::Base} of instances of
      # that matches the given id, selector and the filter. See {file:README.md#markup markup} for more
      # details about formatting the page.
      #
      # example:
      #
      # ```ruby
      # TeamPage.find(1)
      # ```
      #
      # returns the record with id
      #
      # When you don't specify an id, `find` returns the only record on the page.
      # If you have more than one record on the page, `find` raises {MultipleRecords}.
      #
      # example:
      #
      # ```ruby
      # TeamPage.find()
      # ```
      #
      # @param	selector 	[String] selector to use for searching the table on the page
      # @param	filter		[String] filter to use on the records on the page
      #
      # @return	[Pagerecord]	An instance of [PageRecord::Base]
      #
      # @raise	[MultipleRecords] if the page contains more then on set of records
      # @raise 	[RecordNotFound] if the page does not contain any of the specified records
      #
      def find(id = nil, selector = nil, filter = nil)
        selector ||= @selector
        filter ||= @filter
        new(id, selector, filter)
      end

      ##
      #
      # Searches the page and returns an instance of {PageRecord::Base} of instances of
      # that matches the given attribute. See {file:README.md#markup markup} for more
      # details about formatting the page.
      #
      # Although you can call this yourself, {PageRecord::Base} uses this method for defining a
      # finder for all attributes when you define your page class, {PageRecord::Base}
      # See {PageRecord::Base.attributes} for more details.
      #
      # example:
      #
      # ```ruby
      # TeamPage.find_by_name('Ajax')
      # ```
      #
      # returns the record where the name is set to Ajax
      #
      # @param	attribute 	[String] The attribute name
      # @param	value 		[String] The value to search for
      # @param	selector 	[String] selector to use for searching the table on the page
      # @param	filter		[String] filter to use on the records on the page
      #
      # @return	[Pagerecord]	An instance of [PageRecord::Base].
      #
      # @raise	[MultipleRecords] if the page contains more then on set of records
      # @raise 	[RecordNotFound] if the page does not contain any of the specified records
      #
      def find_by_attribute(attribute, value, selector, filter)
        selector ||= @selector
        filter ||= @filter

        context = context_for_selector(selector)
        record = context.find("[data-#{@type}-id]#{filter} > [data-attribute-for='#{attribute}']", text: value)
        parent = record.find(:xpath, '..')
        id = parent["data-#{@type}-id"]
        new(id, selector, filter)
        rescue Capybara::Ambiguous
          raise MultipleRecords, "Found multiple #{@type} record with #{attribute} #{value} on page"
        rescue Capybara::ElementNotFound
          raise RecordNotFound, "#{@type} record with #{attribute} #{value} not found on page"
      end
    end
  end
end
