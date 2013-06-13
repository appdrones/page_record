require 'page_record'

RSpec.configure do |config|
	config.before(:each) do
    PageRecord::PageRecord.page = session
  end
end
