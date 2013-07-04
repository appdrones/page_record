require 'active_support/core_ext'
require "page_record/version"
require "page_record/base"
require "page_record/finders"
require "page_record/instance_actions"
require "page_record/attribute_accessors"
require "page_record/class_actions"
require "page_record/class_methods"
require "page_record/errors"
begin
	require "page_record/helpers"
	require "page_record/form_builder"
rescue
	# probably not in rails. Leave it like this
	# TODO make this beter
end