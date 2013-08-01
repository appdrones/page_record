module PageRecord

  class Base
    include PageRecord::Inspector
    include PageRecord::Attributes
    include PageRecord::Actions
    include PageRecord::Finders
    include PageRecord::Validations

    attr_reader :id
    alias_method :id?, :id

    def initialize(id = nil, selector = nil, filter = nil)
      @page = self.class.page
      @type = self.class.instance_variable_get('@type')
      @id = id.to_s
      find_record(selector, filter)
    end

    ##
    # Set's the default selector for this class
    #
    # Example:
    #
    # ```ruby
    # class TeamPage < PageRecord::Base
    #   selector "#first-table"
    # end
    # ```
    # @param new_selector [String] The default selector to be used for all finders
    #
    def self.selector(new_selector = nil)
      @selector = new_selector if new_selector
      @selector
    end

    ##
    # Set's the default filter for this class
    #
    #
    # Example:
    #
    # ```ruby
    # class TeamPage < PageRecord::Base
    #   filter ".champions-league"
    # end
    # ```
    #
    # @param new_filter [String] The default filter to be used for all finders
    #
    def self.filter(new_filter = nil)
      @filter = new_filter if new_filter
      @filter
    end

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
    # Set's the page {PageRecord::Base} uses for all page operations.
    # when no parameter is given or the parameter is nil, just return the current value
    #
    # @param new_page [Cabybara::Session] The Capybara page
    #
    # @return [Capybara::Session]
    #
    # rubocop:disable AvoidClassVars:
    def self.page (new_page = nil)
      new_page ? @@page = new_page : @@page
    end
    # rubocop:enable AvoidClassVars:

    ##
    # Set's the page host class
    #
    # @param new_host_class an ActiveRecord like class
    #
    # @return [Class]
    #
    def self.host_class (new_host_class = nil)
      if new_host_class
        @host_class = new_host_class
        @host_name =  new_host_class.to_s
        @type = @host_name.underscore
        get_attribute_names
        define_class_methods(self)
        define_instance_methods(self)
      end
      @host_class
    end

    ##
    # Set's the default type for this class
    #
    # @param new_type [Symbol] The default type to be used for all finders. If type is nil just return the current type
    #
    # @return [Symbol] the type set.
    #
    # Example:
    #
    # ```ruby
    # class TopDivisonPage < PageRecord::Base
    #   type :team
    # end
    #
    # TopDivisonPage.type # returns :team
    # ```
    #
    #
    def self.type(new_type = nil)
      new_type ? @type = new_type : @type
    end

    ##
    # Set's the attributes this page recognises. This will override any types
    # inherited from the host class. When you don't specify a parameter, or a nil parameter
    # .attributes will return the current set of attributes
    #
    # @param new_attributes [Array] The attributes the page regognises
    #
    # @return [Array] returns the array of attributes the page recognises
    # Example:
    #
    # ```ruby
    # class TopDivisonPage < PageRecord::Base
    #   attributes [:name, :position, :ranking]
    # end
    # ```
    #
    #
    def self.attributes(new_attributes = nil)
      if new_attributes
        undefine_class_methods(self)
        undefine_instance_methods(self)
        @attributes = new_attributes
        define_class_methods(self)
        define_instance_methods(self)
      end
      @attributes
    end

    ##
    # Add some new attributes to the already availabe attributes
    #
    # @param extra_attributes [Array] The additional attributes the page regognises
    #
    # Example:
    #
    # ```ruby
    # class TopDivisonPage < PageRecord::Base
    #   add_attributes [:full_name, :address_line]
    # end
    # ```
    #
    #
    def self.add_attributes(extra_attributes)
      @attributes.concat(extra_attributes)
      # TODO: check if we can optimise this to only add the new methods
      define_class_methods(self)
      define_instance_methods(self)
      @attributes
    end

    private

    # @private
    def self.set_type_name(base)
      @host_name =  base.to_s.gsub('Page', '')
      @type = @host_name.underscore
      @host_class = @host_name.constantize
      rescue NameError
        @host_name =  ''
        @host_class = ''
    end

    # @private
    def self.get_attribute_names
      @attributes = @host_class.attribute_names.clone
      @attributes.delete('id') # id is a special case attribute
      rescue NameError
        @attributes = []
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
          define_method "find_by_#{attribute}" do | value, selector = '', filter = ''|
            find_by_attribute(attribute, value, selector, filter)
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
          page.find(selector).find(:xpath, '..')
        rescue Capybara::Ambiguous
          raise MultipleRecords, "Found multiple HTML segments with selector #{selector} on page"
        rescue Capybara::ElementNotFound
          raise RecordNotFound, "#{selector} not found on page"
        end
      end
    end

    private

    def find_record(selector, filter)
      selector ||= @selector
      filter ||= @filter
      id_text = @id.blank? ? '' : "='#{@id}'"
      begin
        context = self.class.context_for_selector(selector)
        @record = context.find("[data-#{@type}-id#{id_text}]#{filter}")
        @id = @record["data-#{@type}-id"] if @id.blank?
      rescue Capybara::Ambiguous
        raise MultipleRecords, "Found multiple #{@type} record with id #{@id} on page"
      rescue Capybara::ElementNotFound
        raise RecordNotFound, "#{@type} record with id #{@id} not found on page"
      end
    end

  end
end
