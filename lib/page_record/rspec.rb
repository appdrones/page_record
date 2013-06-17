require 'page_record'

RSpec.configure do |config|
	config.before(:each) do
    PageRecord::Base.page = session
  end
end
