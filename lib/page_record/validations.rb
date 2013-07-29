require 'active_model'

module PageRecord
  module Validations
    ##
    # Searches the record for any errors and returns them
    #
    # @return [ActiveModel::Errors] the error object for the current record
    #
    # @raise [AttributeNotFound] when the attribute is not found in the record
    #
    def errors
      found_errors = @record.all("[data-error-for]")
      error_list = ActiveModel::Errors.new(self)
      found_errors.each do | error |
        attribute = error['data-error-for']
        message = error.text
        error_list.add(attribute, message)
      end
      error_list
    end

    ##
    # Returns true of there are no errors on the current record
    #
    # @return bool
    #
    # @raise [AttributeNotFound] when the attribute is not found in the record
    #
    def valid?
      errors.empty?
    end

    ##
    # Returns true of there are errors on the current record
    #
    # @return bool
    #
    # @raise [AttributeNotFound] when the attribute is not found in the record
    #
    def invalid?
      !valid?
    end

  end
end
