require 'active_support/core_ext'

module PageRecord

	class PageRecord

		def initialize(id)
			@page = self.class.page
			# raise PageNotSet, "page variable not set" unless @page
			@type = self.class.type
			@id = id
			if @id
				begin
					@record = @page.find("[data-#{@type}-id='#{@id}']")
				rescue Capybara::Ambiguous
					raise MultipleRecords, "Found multiple #{@type} record with id #{@id} on page"				
				rescue Capybara::ElementNotFound
					raise RecordNotFound, "#{@type} record with id #{@id} not found on page"
				end
			end
		end


		def self.inherited(base)
			@base_name =  base.to_s.gsub('Record', '')
			@host_class = @base_name.constantize
			@attributes = @host_class.attribute_names
			@attributes.delete('id') # id is a special case attribute
			define_class_methods(base)
			define_instance_methods(base)
		end

	private
		def self.define_instance_methods(base)
			base.type = @base_name.downcase
			attributes = @attributes			
			base.instance_eval do


				attributes.each do | attribute |
					define_method(attribute) do
						element = self.send("#{attribute}_raw")
						tag = element.tag_name
						textelement?(tag) ? element.value : element.text
					end

					define_method("#{attribute}_raw") do
						begin
							@record.find("[data-attribute-for='#{attribute}']")
						rescue Capybara::ElementNotFound
							raise AttributeNotFound, "#{@type} record with id #{@id} doesn't contain attribute #{attribute}"
						end
					end

				end

				define_method :id do
					@id
				end

				define_method :id_raw do
					@id
				end

			end
		end


		def self.define_class_methods(base)
			eigenclass = class << base; self; end
			attributes = @attributes
			eigenclass.instance_eval do
				attr_accessor :page, :type


				define_method :all do
					records = []
					@page.all("[data-#{@type}-id]").each do | record|
						id = record["data-#{@type}-id"]
						records << self.new(id)
					end
					records
				end

				define_method :find do | id|
					self.new(id)
				end

				attributes.each do | attribute|
					define_method "find_by_#{attribute}" do | value|
						begin
							record = @page.find("[data-#{@type}-id] > [data-attribute-for='#{attribute}']:contains('#{value}'):parent")
							id = record.native.parent["data-#{@type}-id"]
							self.new(id)
							rescue Capybara::Ambiguous
								raise MultipleRecords, "Found multiple #{@type} record with #{attribute} #{value} on page"				
							rescue Capybara::ElementNotFound
								raise RecordNotFound, "#{@type} record with #{attribute} #{value} not found on page"
							end
						end
					end
			end
		end


		def textelement?(tag)
			case tag
			when 'textarea', 'input' then true
			else false
			end
		end
  end
end
