module PageRecord
	class PageRecord
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
			element.set(value)
		end


private
		def textelement?(tag)
			case tag
			when 'textarea', 'input' then true
			else false
			end
		end
	end
end
