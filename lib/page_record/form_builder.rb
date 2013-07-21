module PageRecord

  class FormBuilder < ActionView::Helpers::FormBuilder
    include PageRecord::Helpers

    helpers = field_helpers + [:time_zone_select, :date_select] - [:hidden_field, :fields_for, :label]
    helpers.each do |helper|
      define_method helper do |field, *args|
        options = args.find { |a| a.is_a?(Hash) } || {}
        super field, options.merge(attribute_for(field))
      end
    end

    actions = %w(submit button)
    actions.each do |helper|
      define_method helper do |field, *args|
        options = args.find { |a| a.is_a?(Hash) } || {}
        super field, options.merge(action_for(field.downcase))
      end
    end

  end
end
