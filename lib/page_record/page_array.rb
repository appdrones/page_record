class PageArray
	def initialize(page, type, selector = "", filter = "", selector_type = :css)
		@type = type
		@page = page
		case( selector_type)
			when :css
				if selector.blank?
					@selector = ""
				else
					@selector = Nokogiri::CSS.xpath_for(selector)[0]
				end
				if filter.blank?
					@filter = ""
				else
					@filter = Nokogiri::CSS.xpath_for(filter)[0]
				end
			when :xpath
				@selector = selector
				@filter = filter
			else
				raise "invalid selector type. Use :css or :xpath"
		end
		@klass = type.to_s.camelize.constantize
		@attributes = @klass.attribute_names
		@attributes.delete('id')
		@attributes.each do | attribute |
		  self.class_eval do
				define_method("find_by_#{attribute}") do | value|
					@filter << "/descendant-or-self::*[@data-attribute-for='#{attribute}']/descendant-or-self::*[contains(.,'#{value}')]"
			  	PageRecord.new(@page, @type, "", @selector, @filter, :xpath)
				end
			end
		end
	end

	def find(id)
		PageRecord.new(@page, @type, id, @selector, @filter, :xpath)		
	end


	def all()
		if @selector.blank?
			context = @page
		else
			context = @page.find(@selector)
		end

	  context.all(:xpath, "//*[@data-#{@type}-id]#{@filter}").collect do | record| 
	  	debugger
	  	id = record["data-#{@type}-id"]
	  	PageRecord.new(@page, @type, id, @selector, @filter, :xpath)
	  end
	end

end

