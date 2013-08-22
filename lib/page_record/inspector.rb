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

    # @private
    def attributes
      attributes = {}
      self.class.attributes.each do | attribute|
        begin
          attributes[attribute] = read_attribute(attribute) do
            @record.all("[data-attribute-for='#{attribute}']").first
          end
        rescue NoMethodError
          attributes[attribute] = '--not found on page--'
        end
      end
     attributes['id'] = id
     attributes
    end

    module ClassMethods
      def inspect
        {
          type:         type,
          host_class:   host_class,
          selector:     selector,
          filter:       filter,
          attributes:   attributes,
          actions:      actions
        }
      end
    end
  end
end
