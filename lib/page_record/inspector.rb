module PageRecord

  module Inspector


    def self.included(base)
      base.extend(ClassMethods)
    end

    def inspect
      {
        attributes: attributes,
        actions: actions
      }
    end

    private
    #@private
    def attributes
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
          actions:      self.actions
      	}
      end
    end

  end
end
