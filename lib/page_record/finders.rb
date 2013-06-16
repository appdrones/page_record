module PageRecord
	class PageRecord

		def self.all(selector = nil, filter = nil)
			selector ||= self.instance_variable_get('@selector')
			filter ||= self.instance_variable_get('@filter')
			records = []
			context = context_for_selector(selector)				
			context.all("[data-#{@type}-id]#{filter}").each do | record|
				id = record["data-#{@type}-id"]
				records << self.new(id, selector)
			end
			records
		end

		def self.find(id=nil, selector = nil, filter= nil)
			selector ||= self.instance_variable_get('@selector')
			filter ||= self.instance_variable_get('@filter')
			self.new(id, selector, filter)
		end

		def self.find_by_attribute(attribute, value, selector, filter)
			begin
				selector ||= self.instance_variable_get('@selector')
				filter ||= self.instance_variable_get('@filter')
				
				context = self.context_for_selector(selector)
				record = context.find("[data-#{@type}-id]#{filter} > [data-attribute-for='#{attribute}']", :text => value)
				parent = record.find(:xpath, "..")
				id = parent["data-#{@type}-id"]
				self.new(id, selector)
				rescue Capybara::Ambiguous
					raise MultipleRecords, "Found multiple #{@type} record with #{attribute} #{value} on page"				
				rescue Capybara::ElementNotFound
					raise RecordNotFound, "#{@type} record with #{attribute} #{value} not found on page"
			end
		end
	end
end
