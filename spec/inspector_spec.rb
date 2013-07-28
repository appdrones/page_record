require_relative  './spec_helper'

describe PageRecord::Inspector do


	describe '.inspect' do
	  before do
	    class TeamPage < PageRecord::Base
	    	selector 	'.selector'
	    	filter 		'.filter'
	    	attributes %w(a b c d e)
	    end
	    PageRecord::Base.page page
	  end

    after do
      Object.send(:remove_const, :TeamPage)
    end


		shared_context "page with all elements"

		it "returns the type" do
			expect(TeamPage.inspect[:type]).to eq 'team'
		end

		it "returns the host_class" do
			expect(TeamPage.inspect[:host_class]).to eq Team
		end

		it "returns the selector" do
			expect(TeamPage.inspect[:selector]).to eq '.selector'
		end

		it "returns the filter" do
			expect(TeamPage.inspect[:filter]).to eq '.filter'
		end

		it "returns all attributes" do
			expect(TeamPage.inspect[:attributes]).to eq %w(a b c d e)
		end


	end

	describe '#inspect' do

	  before do
	    class TeamPage < PageRecord::Base; end
	    PageRecord::Base.page page
	  end

    after do
      Object.send(:remove_const, :TeamPage)
    end

	  include_context "page with single table with 3 records"

	  subject { TeamPage.find(1).inspect }

	  it 'returns all attributes' do
	  	expect(subject['ranking']).to eq '1'
	  	expect(subject['name']).to eq 'Ajax'
	  	expect(subject['points']).to eq '10'
	  	expect(subject['goals']).to eq '--not found on page--'
	  end

	end
end

