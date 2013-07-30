require_relative  './spec_helper'

describe PageRecord::Inspector do

  include_context "page with single table with 3 records"

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

		it "returns all actions" do
			expect(TeamPage.inspect[:actions]).to include 'edit', 'next'
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


	  subject { TeamPage.find(1).inspect }

	  it 'returns all attributes' do
	  	expect(subject[:attributes]['ranking']).to eq '1'
	  	expect(subject[:attributes]['name']).to eq 'Ajax'
	  	expect(subject[:attributes]['points']).to eq '10'
	  	expect(subject[:attributes]['goals']).to eq '--not found on page--'
	  end

		it "returns all actions" do
			expect(subject[:actions]).to include 'edit'
		end 

	end
end

