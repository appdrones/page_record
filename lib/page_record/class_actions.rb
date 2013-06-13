module PageRecord
	class PageRecord

		def self.method_missing(action)
			raw_action = /(.*)\?/.match(action)
			begin
				if raw_action
					action_for?(raw_action[1])
				else
					action_for(action)
				end
			rescue Capybara::Ambiguous
				raise MultipleRecords, "Found multiple #{action} tags for #{@type} on page"				
			rescue Capybara::ElementNotFound
				super
			end
		end


private


		def self.action_for(action)
			element = action_for?(action)
			element.click
			element
		end


		def self.action_for?(action)
			page.find("[data-action-for='#{action}']")
		end
	end
end


