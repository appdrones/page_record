# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/page_record/(.+)\.rb$})  { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')       		 { "spec" }
  watch('spec/support/*.rb')          	 { "spec" }
  watch('spec/support/views/*.erb')   	 { "spec" }
end

