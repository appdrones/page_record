
module PageRecord

	class PageRecord

		attr_reader :id
		alias :id_raw :id

		def initialize(id, selector="", filter="")
			@page = self.class.page
			# raise PageNotSet, "page variable not set" unless @page
			@type = self.class.type
			@id = id.to_s
			if @id
				begin
					context = self.class.context_for_selector(selector)
					@record = context.find("[data-#{@type}-id='#{@id}']#{filter}")
				rescue Capybara::Ambiguous
					raise MultipleRecords, "Found multiple #{@type} record with id #{@id} on page"				
				rescue Capybara::ElementNotFound
					raise RecordNotFound, "#{@type} record with id #{@id} not found on page"
				end
			end
		end

		def method_missing(action)
			begin
				element = @record.find("[data-action-for='#{action}']")
				debuggertspec_
				element.native.click
			rescue Capybara::ElementNotFound
				super
			end

		end


	private

		def read_attribute_raw(attribute)
			begin
				@record.find("[data-attribute-for='#{attribute}']")
			rescue Capybara::ElementNotFound
				raise AttributeNotFound, "#{@type} record with id #{@id} doesn't contain attribute #{attribute}"
			end
		end

		def read_attribute( attribute)
			element = self.send("#{attribute}_raw")
			tag = element.tag_name
			textelement?(tag) ? element.value : element.text
		end

		def write_attribute( attribute, value)
			element = self.send("#{attribute}_raw")
			tag = element.tag_name
			raise NotInputField unless textelement?(tag)
			element.native['value'] = value			
		end


		def textelement?(tag)
			case tag
			when 'textarea', 'input' then true
			else false
			end
		end
  end
end
