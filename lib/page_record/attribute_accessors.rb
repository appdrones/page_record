module PageRecord
  class Base
    ##
    # Searches the record for the specified attribute and returns
    # the {http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Result Capybara Result}.
    # This method is called when you access an attribute with a `?` of a record
    #
    # @return [Capybara::Result] the text content of the specified attribute
    #
    # @raise [AttributeNotFound] when the attribute is not found in the record
    #
    def read_attribute?(attribute)
      @record.find("[data-attribute-for='#{attribute}']")
      rescue Capybara::ElementNotFound
        raise AttributeNotFound, "#{@type} record with id #{@id} doesn't contain attribute #{attribute}"
    end

    ##
    # Searches the record for the specified attribute and returns
    # the text content. This method is called when you access an
    # attribute of a record
    #
    # @return [String] the text content of the specified attribute
    #
    # @raise [AttributeNotFound] when the attribute is not found in the record
    #
    def read_attribute(attribute)
      element = send("#{attribute}?")
      tag = element.tag_name
      textelement?(tag) ? element.value : element.text
    end

    ##
    # Searches the record for the specified attribute and sets the value of the attribute
    # This method is called when you set an attribute of a record
    #
    # @return [Capybara::Result] the text content of the specified attribute
    #
    # @raise [AttributeNotFound] when the attribute is not found in the record
    # @raise [NotInputField] when the attribute is not a `TEXTAREA` or `INPUT` tag
    #
    def write_attribute(attribute, value)
      element = send("#{attribute}?")
      tag = element.tag_name
      raise NotInputField unless textelement?(tag)
      element.set(value)
      element
    end

    private

    # @private
    def textelement?(tag)
      case tag
      when 'textarea', 'input' then true
      else false
      end
    end
  end
end
