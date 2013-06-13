module PageRecord
	class PageRecord
		def method_missing(action)
			raw_action = /(.*)\?/.match(action)
			begin
				if raw_action
					action_for?(raw_action[1])
				else
					action_for(action)
				end
			rescue Capybara::ElementNotFound
				super
			end
		end


	private


		def action_for(action)
			element = action_for?(action)
			element.click
			element
		end

		def action_for?(action)
			@record.find("[data-action-for='#{action}']")
		end
	end
end

