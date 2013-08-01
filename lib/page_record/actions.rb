module PageRecord
  module Actions

    def self.included(base)
      base.extend(ClassMethods)
    end

    ##
    # This is the implementation of the record action routine. It has two variants.
    # it has a `?` variant and a `normal` variant.
    #
    # normal variant:
    # It checks the page for a data-action-for='action' tag somewhere on the page.
    # If it finds it, it clicks it.
    #
    # `?` variant:
    # It checks the page for a data-action-for='action' tag somewhere on the page.
    # If it finds it, returns the Capybara element.
    #
    # @param action [Symbol] this is the name of the action
    #
    # @return [Capybara::Result]
    #
    # @raise [PageRecord::MultipleRecords] when there are more actions with
    #   this name on the page
    #
    def method_missing(action)
      self.class.method_missing(action)
    end

    protected

    # @private
    def actions
      self.class.send('actions_on?', @record)
    end

    private

    # @private
    def action_for(action)
      element = action_for?(action)
      element.click
      element
    end

    # @private
    def action_for?(action)
      @record.find("[data-action-for='#{action}']")
    end

    module ClassMethods

      ##
      #
      # This is the implementation of the page action routine. It has two variants.
      # it has a `?` variant and a `normal` variant.
      #
      # normal variant:
      # It checks the page for a data-action-for='action' tag somewhere on the page.
      # If it finds it, it clicks it.
      #
      # `?` variant:
      # It checks the page for a data-action-for='action' tag somewhere on the page.
      # If it finds it, returns the Capybara result.
      #
      # @param action [Symbol] this is the name of the action
      #
      # @return [Capybara::Element]
      #
      # @raise [PageRecord::MultipleRecords] when there are more actions with
      #   this name on the page
      #
      def method_missing(action)
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

      protected

      # @private
      def actions
        actions_on?(page)
      end

      # @private
      def actions_on?(context)
        actions = context.all('[data-action-for]')
        action_hash = {}
        actions.each do | action|
          name = action['data-action-for']
          action_hash[name] = { tag: action.tag_name, text: action.text }
        end
        action_hash
      end

      private

      # @private
      def action_for(action)
        element = action_for?(action)
        element.click
        element
      end

      # @private
      def action_for?(action)
        page.find("[data-action-for='#{action}']")
      end
    end
  end
end
