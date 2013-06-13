module PageRecord
	class PageRecord

		def self.inherited(base)
			base.class_eval do
				@base_name =  base.to_s.gsub('Page', '')
				@type = @base_name.downcase
				@host_class = @base_name.constantize
				@attributes = @host_class.attribute_names.clone
				@attributes.delete('id') # id is a special case attribute
			end
			define_class_methods(base)
			define_instance_methods(base)
		end

	  class << self
	    attr_accessor :type
	  end

	  def self.page=(new_page)
	  	@@page = new_page
	  end

	  def self.page
	  	@@page
	  end

	  def self.attributes(new_attributes)
	  	undefine_class_methods(self)
	  	undefine_instance_methods(self)
	  	@attributes = new_attributes
	  	define_class_methods(self)
	  	define_instance_methods(self)
	  end


private


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


		def self.undefine_accessor_methods(base)
			base.instance_eval do
				@attributes.each do | attribute |
					remove_method("#{attribute}?")
					remove_method(attribute) 
					remove_method("#{attribute}=")
				end
			end
		end

		def self.undefine_class_methods(base)
			eigenclass = class << base; self; end
			attributes = base.instance_variable_get('@attributes')
 			eigenclass.instance_eval do
				attributes.each do | attribute|
					remove_method "find_by_#{attribute}"
				end
			end
		end



		def self.define_instance_methods(base)
			define_accessor_methods(base)		
		end

		def self.undefine_instance_methods(base)
			undefine_accessor_methods(base)		
		end


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

		def self.undefine_class_methods(base)
			eigenclass = class << base; self; end
			attributes = base.instance_variable_get('@attributes')
 			eigenclass.instance_eval do
				attributes.each do | attribute|
					remove_method "find_by_#{attribute}"
				end
			end
		end


		def self.context_for_selector(selector)
			if selector.blank?
				page
			else
				begin
					page.find(selector)
					rescue Capybara::Ambiguous
						raise MultipleRecords, "Found multiple HTML segments with selector #{selector} on page"				
					rescue Capybara::ElementNotFound
						raise RecordNotFound, "#{selector} not found on page"						
				end
			end				
		end

	end
end