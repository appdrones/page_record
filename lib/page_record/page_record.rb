
module PageRecord

	class PageRecord

		attr_reader :id
		alias :id? :id

		def initialize(id=nil, selector=nil, filter=nil)
			selector ||= self.instance_variable_get('@selector')
			filter ||= self.instance_variable_get('@filter')
			@page = self.class.page
			# raise PageNotSet, "page variable not set" unless @page
			@type = self.class.type
			@id = id.to_s
			id_text = @id.blank? ? "" : "='#{@id}'"
			begin
				context = self.class.context_for_selector(selector)
				@record = context.find("[data-#{@type}-id#{id_text}]#{filter}")
				@id = @record["data-#{@type}-id"] if @id.blank?
			rescue Capybara::Ambiguous
				raise MultipleRecords, "Found multiple #{@type} record with id #{@id} on page"				
			rescue Capybara::ElementNotFound
				raise RecordNotFound, "#{@type} record with id #{@id} not found on page"
			end
		end

  end
end
