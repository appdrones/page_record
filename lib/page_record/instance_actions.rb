module PageRecord
	class PageRecord
		def method_missing(action)
			raw_action = /(.*)\?/.match(action)
			begin
				if raw_action
					raw_action_for(raw_action[0])
				else
					action_for(action)
				end
			rescue Capybara::ElementNotFound
				super
			end
		end


	private

		def action_for(action)
			element = raw_action_for(action)
			element.native.click
			element
		end

		def raw_action_for(action)
			@record.find("[data-action-for='#{action}']")
		end
	end
end

