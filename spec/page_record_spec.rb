require_relative  './spec_helper'

describe PageRecord::PageRecord do

	include_context "page with single table with 3 records" # Default context

	before do
	  class TeamPage < PageRecord::PageRecord; end
		TeamPage.page = page
	end

  describe ".page=" do
  	before do
  		TeamPage.page = nil # reset for the spec
  	end

  	subject {TeamPage.page = page }

  	it "sets the page" do
			expect{subject}.to change{TeamPage.page}.from(nil).to(page)  		
  	end
  end

  describe ".page" do

  	subject {TeamPage.page}

  	it "gets the page" do
			expect(subject).to eq page  		
  	end
  end


	describe ".all" do


		subject {TeamPage.all( selector, filter) }

		context "one set of records available on the page" do
			let(:selector)	{""}
			let(:filter)	{""}

			it_behaves_like "valid call of .all"

			context "with a filter" do
				let(:filter)	{".champions_league"}

					it "returns only the elements that contain the filter css" do
						expect( subject.map {|c| c.name}).not_to include('Feijenoord')
						expect( subject.map {|c| c.name}).to include(*['Ajax', 'PSV'])
					end


			end


		end

		context "No records available on the page" do

			include_context "page without records"
			let(:selector)	{""}
			let(:filter)	{""}


			it "returns an empty Array" do
				expect(subject).to eq []
			end

		end

		context "multiple sets of records avialable on the page" do
			include_context "page with two tables with 3 records" 

			context "without selector" do
				let(:selector)	{""}
				let(:filter)	{""}


				it "raises error PageRecord::MultipleRecords" do
					expect{subject}.to raise_error(PageRecord::MultipleRecords)
				end

			end

			it_behaves_like "handles invalid selectors"

			context "with a correct selector" do

				let(:selector)	{"#first-table"}
				let(:filter)	{""}

				it_behaves_like "valid call of .all"

			end

		end

	end	


	describe "inherited class" do

		subject {TeamPage.new(1) }

			it "responds to all attributes of corresponding AR Class" do
				Team.attribute_names.each do |attribute|
					expect(subject).to respond_to(attribute)
				end
			end

			it "responds <attribute>_raw of corresponding AR Class" do
				Team.attribute_names.each do |attribute|
					expect(subject).to respond_to("#{attribute}_raw")
				end
			end


	end

	describe ".find" do

		subject {TeamPage.find(record_number, selector, filter) }
		let(:selector) { ""}
		let(:filter) {""}

		context "one found on the page" do

			let(:record_number) { 1}

			it_behaves_like "a valid call of .find"


			it_behaves_like "it handles filters"


		end

		context "multiple record found on the page" do

			let(:record_number) { 1}
			include_context "page with duplicate records"

			subject {TeamPage.find(1) }

			it "raises error PageRecord::MultipleRecords" do
				expect{subject}.to raise_error(PageRecord::MultipleRecords)
			end

		end


		context "no record on the page" do

			let(:record_number) { 37373}

			it "raises error PageRecord::RecordNotFound" do
				expect{subject}.to raise_error(PageRecord::RecordNotFound)
			end

		end

		context "multiple sets of records available on the page" do
			include_context "page with two tables with 3 records" 
			let(:record_number) {1}

			context "without selector" do
				let(:selector)	{""}

				it "raises error PageRecord::MultipleRecords" do
					expect{subject}.to raise_error(PageRecord::MultipleRecords)
				end

			end

			it_behaves_like "handles invalid selectors"

			context "with a correct selector" do

				let(:selector)	{"#first-table"}
				it_behaves_like "a valid call of .find"

			end

		end

	end	

	describe "find_by..." do

		subject { TeamPage.find_by_name(name, selector, filter)}
		let(:selector) { ""}
		let(:filter) {""}

		context "no record on page" do
			let(:name) {"unknown name"}

			it "raises error PageRecord::RecordNotFound" do
				expect{subject}.to raise_error(PageRecord::RecordNotFound)
			end

		end

		context "multiple records on page" do
			let(:name) {"Ajax"}
			include_context "page with duplicate records"

			it "raises error PageRecord::MultipleRecords" do
				expect{subject}.to raise_error(PageRecord::MultipleRecords)
			end

		end

		context "one record on page" do
			let(:name) {"Ajax"}

			it_behaves_like "a valid call of .find"
			it_behaves_like "it handles filters"

		end

		context "multiple sets of records avialable on the page" do
			include_context "page with two tables with 3 records" 
			let(:name) {"Ajax"}

			context "without selector" do
				let(:selector)	{""}

				it "raises error PageRecord::MultipleRecords" do
					expect{subject}.to raise_error(PageRecord::MultipleRecords)
				end

			end

			it_behaves_like "handles invalid selectors"

			context "with a correct selector" do

				let(:selector)	{"#first-table"}
				let(:name) {"Ajax"}
				it_behaves_like "a valid call of .find"

			end

		end



	end

	describe "#..._raw " do

		subject {TeamPage.find(1)}

		context "attribute is on page" do

			it "returns the dom object" do
				expect( subject.name_raw.class).to eq Capybara::Node::Simple
			end
		end

		context "attribute not on page" do

			it "raises error PageRecord::AttributeNotFound" do
				expect{subject.goals_raw}.to raise_error(PageRecord::AttributeNotFound)
			end

		end
	end

	describe "#... valid attribute getter" do

		subject {TeamPage.find(1)}
  	include_context "page with single table with 3 records"

		context "attribute is on page" do

			it "returns a the value on the page" do
				expect( subject.name).to eq 'Ajax'
			end
		end

		context "attribute not on page" do

			it "raises error PageRecord::AttributeNotFound" do
				expect{subject.goals}.to raise_error(PageRecord::AttributeNotFound)
			end

		end


	end

end