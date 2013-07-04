module PageRecord

  class FormBuilder < ActionView::Helpers::FormBuilder
    include PageRecord::Helpers

    helpers = field_helpers + %w(time_zone_select date_select) - %w(hidden_field fields_for label)
    helpers.each do |helper|
      define_method helper do |field, *args|
        options = args.detect{ |a| a.is_a?(Hash) } || {}
        super field, options.merge(attribute_for(field))
      end
    end

    actions = ['submit','button']
    actions.each do |helper|
      define_method helper do |field, *args|
        options = args.detect{ |a| a.is_a?(Hash) } || {}
        super field, options.merge(action_for(field.downcase))
      end
    end

  end
end
