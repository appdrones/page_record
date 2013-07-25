require 'active_support/core_ext'
require 'page_record/version'
require 'page_record/base'
require 'page_record/finders'
require 'page_record/instance_actions'
require 'page_record/attribute_accessors'
require 'page_record/class_actions'
require 'page_record/class_methods'
require 'page_record/errors'
require 'page_record/validation'
if defined?(ActionView::Base)
  require 'page_record/helpers'
  require 'page_record/form_builder'
end
require 'page_record/formtastic' if defined?(Formtastic::Helpers::FormHelper)

