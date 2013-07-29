require 'active_support/core_ext'
require 'page_record/version'
require 'page_record/inspector'
require 'page_record/attributes'
require 'page_record/actions'
require 'page_record/finders'
require 'page_record/validations'
require 'page_record/base'
require 'page_record/errors'
if defined?(ActionView::Base)
  require 'page_record/helpers'
  require 'page_record/form_builder'
end
require 'page_record/formtastic' if defined?(Formtastic::Helpers::FormHelper)

