module Formtastic

  module Inputs
    module Base
      module Html

        alias_method :input_html_options_org, :input_html_options

        #
        # This is a replacement method for the original `input_html_options` method from `Formtastic`
        # The only thing it does, is merge the `attribute_for` into the output. The `input_html_options` is called
        # for all input methods
        #

        def input_html_options
          extend(PageRecord::Helpers)
          input_html_options_org.merge(attribute_for(input_name))
        end
      end
    end
  end

  module Actions
    module Buttonish

      alias_method :extra_button_html_options_org, :extra_button_html_options

      #
      # This is a replacement method for the original `extra_button_html_options` method from `Formtastic`
      # The only thing it does, is merge the `action_for` into the output. The `extra_button_html_options` is called
      # for all action methods
      #
      def extra_button_html_options
        extend(PageRecord::Helpers)
        extra_button_html_options_org.merge(action_for(@method))
      end

    end
  end

  module Helpers
    module FormHelper

      alias_method :semantic_form_for_org, :semantic_form_for

      #
      # This is a replacement method for the original `semantic_form_for` method from `Formtastic`.
      # The only thing it does, is merge the `form_record_for` into the output.
      #
      def semantic_form_for(record_or_name_or_array, *args, &proc)
        extend(PageRecord::Helpers)
        options = args.extract_options!
        options ||= {}
        case record_or_name_or_array
        when String, Symbol
          object_name = record_or_name_or_array
        else
          object      = record_or_name_or_array.is_a?(Array) ? record_or_name_or_array.last : record_or_name_or_array
          raise ArgumentError, 'First argument in form cannot contain nil or be empty' unless object
          object_name = options[:as] || model_name_from_record_or_class(object).param_key
        end
        options = options.merge(html: form_record_for(object_name))
        args << options
        semantic_form_for_org(record_or_name_or_array, *args, &proc)
      end
    end
  end
end
