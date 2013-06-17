module PageRecord
	class PageRecord

		# @private
		def self.inherited(base)
			base.class_eval do
				set_type_name(base)
				get_attribute_names
			end
			define_class_methods(base)
			define_instance_methods(base)
		end


		##
		# Set's the page {PageRecord::PageRecord} uses for all page operations
		#
		# @param new_page [Cabybara::Session] The Capybara page	
		#
		# @return [Capybara::Session]
		#
		def self.page=(new_page)
			@@page = new_page
		end

		##
		# Returns the page page {PageRecord::PageRecord} uses for all page operations
		#
		# @return [Capybara::Session]
		#
	  def self.page
	  	@@page
	  end

		##
		# Set's the default selector for this class 
		#
		# Example:
		#
		# ```ruby
		# class TeamPage < PageRecord::PageRecord
		#   selector "#first-table" 
		# end
		#```
		# @param new_selector [String] The default selector to be used for all finders	
		#
	  def self.selector( new_selector)
	  	@selector = new_selector
	  end

		##
		# Set's the default filter for this class 
		#
		#
		# Example:
		#
		# ```ruby
		# class TeamPage < PageRecord::PageRecord
		#   filter ".champions-league" 
		# end
		#```
		#
		# @param new_filter [String] The default filter to be used for all finders	
		#
	  def self.filter( new_filter)
	  	@filter = new_filter
	  end

		##
		# Set's the default type for this class 
		#
		# @param new_type [Symbol] The default type to be used for all finders	
		#
		# Example:
		#
		# ```ruby
		# class TopDivisonPage < PageRecord::PageRecord
		#   type :team
		# end
		#```
		#
		#
	  def self.type( new_type)
	  	@type = new_type
	  end


		##
		# Set's the attributes this page recognises. This will override any types 
		# inherited from the host class 
		#
		# @param new_attributes [Array] The attributes the page regognises	
		#
		# Example:
		#
		# ```ruby
		# class TopDivisonPage < PageRecord::PageRecord
		#   attributes [:name, :position, :ranking]
		# end
		#```
		#
		#
	  def self.attributes(new_attributes)
	  	undefine_class_methods(self)
	  	undefine_instance_methods(self)
	  	@attributes = new_attributes
	  	define_class_methods(self)
	  	define_instance_methods(self)
	  end


private

		# @private
		def self.set_type_name(base)
			@base_name =  base.to_s.gsub('Page', '')
			@type = @base_name.underscore
		end

		# @private
		def self.get_attribute_names
			begin
				@host_class = @base_name.constantize
				@attributes = @host_class.attribute_names.clone
				@attributes.delete('id') # id is a special case attribute
			rescue NameError
				@attributes = []
			end
		end


		# @private
		def self.define_accessor_methods(base)
			base.instance_eval do
				@attributes.each do | attribute |
					define_method("#{attribute}?") do
						read_attribute?(attribute)
					end
					define_method(attribute) do
						read_attribute(attribute)
					end
					define_method("#{attribute}=") do | value|
						write_attribute(attribute, value)
					end
				end
			end
		end


		# @private
		def self.undefine_accessor_methods(base)
			base.instance_eval do
				@attributes.each do | attribute |
					remove_method("#{attribute}?")
					remove_method(attribute) 
					remove_method("#{attribute}=")
				end
			end
		end


		# @private
		def self.define_instance_methods(base)
			define_accessor_methods(base)		
		end

		# @private
		def self.undefine_instance_methods(base)
			undefine_accessor_methods(base)		
		end


		# @private
		def self.define_class_methods(base)
			eigenclass = class << base; self; end
			attributes = base.instance_variable_get('@attributes')
 			eigenclass.instance_eval do
				attributes.each do | attribute|
					define_method "find_by_#{attribute}" do | value, selector = "", filter = ""|
						find_by_attribute( attribute, value, selector, filter)
					end
				end
			end
		end

		# @private
		def self.undefine_class_methods(base)
			eigenclass = class << base; self; end
			attributes = base.instance_variable_get('@attributes')
 			eigenclass.instance_eval do
				attributes.each do | attribute|
					remove_method "find_by_#{attribute}"
				end
			end
		end


		# @private
		def self.context_for_selector(selector)
			if selector.blank?
				page
			else
				begin
					page.find(selector).find(:xpath, "..")
					rescue Capybara::Ambiguous
						raise MultipleRecords, "Found multiple HTML segments with selector #{selector} on page"				
					rescue Capybara::ElementNotFound
						raise RecordNotFound, "#{selector} not found on page"						
				end
			end				
		end

	end
end