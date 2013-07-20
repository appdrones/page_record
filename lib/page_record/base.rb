module PageRecord

  class Base

    attr_reader :id
    alias_method :id?, :id

    def initialize(id = nil, selector = nil, filter = nil)
      @page = self.class.page
      @type = self.class.instance_variable_get('@type')
      @id = id.to_s
      find_record(selector, filter)
    end

    private

    def find_record(selector, filter)
      selector ||= instance_variable_get('@selector')
      filter ||= instance_variable_get('@filter')
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
