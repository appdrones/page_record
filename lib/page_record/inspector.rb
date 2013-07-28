module PageRecord

  module Inspector


    def self.included(base)
      base.extend(ClassMethods)
    end

    def inspect
    	attributes = Hash.new
    	self.class.attributes.each do | attribute|
    		begin
	    		attributes[attribute] = self.send(attribute)
    		rescue AttributeNotFound
    			attributes[attribute] = '--not found on page--'
    		end
    	end
    	attributes
    end


    module ClassMethods
      def inspect
      	{
      		type: 				self.type,
      		host_class: 	self.host_class,
      		selector: 		self.selector,
      		filter: 			self.filter,
      		attributes: 	self.attributes,
      	}
      end
    end

  end
end
