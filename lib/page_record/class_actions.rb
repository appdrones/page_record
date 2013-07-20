module PageRecord
  class Base
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
    def self.method_missing(action)
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

    private

      # @private
      def self.action_for(action)
        element = action_for?(action)
        element.click
        element
      end

      # @private
      def self.action_for?(action)
        page.find("[data-action-for='#{action}']")
      end
  end
end
