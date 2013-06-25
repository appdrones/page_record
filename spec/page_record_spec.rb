require_relative  './spec_helper'

describe PageRecord::Base do

	include_context "page with single table with 3 records" # Default context

	before do
	  class TeamPage < PageRecord::Base; end
		PageRecord::Base.page page
	end

  describe ".type" do

  	before do
	  	class CamelCase
				def self.attribute_names
					[ 'id' , 'name', 'points', 'ranking', 'goals']
				end
			end
		end

		after do 
			Object.send(:remove_const, :CamelCasePage)
		end


		context "no type given" do

			before do
				class CamelCasePage < PageRecord::Base; end
			end

			it "returns the internal type of the class " do
				expect( CamelCasePage.type).to eq "camel_case"
			end
		end

		context "a type given" do

			before do
				class CamelCasePage < PageRecord::Base
					type :team
				end
			end

			it "sets the internal type of the class" do
				expect( CamelCasePage.type).to eq :team
			end
		end


  end


  describe ".attributes" do

  	after do
			Object.send(:remove_const, :TeamPage)
  	end

  	context "no parameter given" do

  		it "returns all current recognised attributes" do
				expect(TeamPage.attributes).to eq ['name', 'points', 'ranking', 'goals'] 		
			end
  	end

  	context "parameter given" do

	  	subject { TeamPage}

	  	before do
			  class TeamPage < PageRecord::Base
					attributes ['country', 'stadium']
			  end
	  	end

	  	it "clears all old class methods" do
				expect(subject).not_to respond_to(:find_by_name)  		
				expect(subject).not_to respond_to(:find_by_ranking)  		
	  	end

	  	it "adds new class methods to class " do
				expect(subject).to respond_to(:find_by_country)
				expect(subject).to respond_to(:find_by_stadium)	
	  	end

	  	it "clears all old instance methods" do
				expect(subject.new(1)).not_to respond_to(:name)  		
				expect(subject.new(1)).not_to respond_to(:ranking)  		
	  	end

	  	it "adds new class methods to class " do
				expect(subject.new(1)).to respond_to(:country)
				expect(subject.new(1)).to respond_to(:stadium)	
	  	end

  		it "returns all current recognised attributes" do
				expect(TeamPage.attributes).to eq ['country', 'stadium'] 		
			end
	  end

  end


  describe ".add_attributes" do
  	before do
		  class TeamPage < PageRecord::Base
				add_attributes ['country', 'stadium']
		  end
  	end

  	after do
			Object.send(:remove_const, :TeamPage)
  	end

  	subject { TeamPage}


  	it "keeps all old class methods" do
			expect(subject).to respond_to(:find_by_name)  		
			expect(subject).to respond_to(:find_by_ranking)  		
  	end

  	it "adds new class methods to class " do
			expect(subject).to respond_to(:find_by_country)
			expect(subject).to respond_to(:find_by_stadium)	
  	end

  	it "keeps all old instance methods" do
			expect(subject.new(1)).to respond_to(:name)  		
			expect(subject.new(1)).to respond_to(:ranking)  		
  	end

  	it "adds new class methods to class " do
			expect(subject.new(1)).to respond_to(:country)
			expect(subject.new(1)).to respond_to(:stadium)	
  	end

  	it "returns all current attributes" do
  		expect(subject.add_attributes ['more']).to eq ['name', 'points', 'ranking', 'goals', 'country', 'stadium', 'more' ]
  	end


  end




  describe ".page" do

  	context "with a parameter" do
	  	let(:test_page) { Object.new}
	  	subject {PageRecord::Base.page test_page }

	  	it "sets the page when called on PageRecord::Base" do
				expect{subject}.to change{PageRecord::Base.page}.to(test_page)  		
	  	end

	  	it "sets the page when called on subclass" do
				expect{TeamPage.page test_page}.to change{PageRecord::Base.page}.to(test_page)  		
	  	end
	  end

	  context "without a parameter" do
	  	it "gets the page on PageRecord::Base" do
				expect(PageRecord::Base.page).to eq page  		
	  	end

	  	it "gets the page on subclass" do
				expect(TeamPage.page).to eq page  		
	  	end
	  end


  end


  describe ".host_class" do

		before do
			class FunnyRecord < PageRecord::Base
				host_class Team
			end
		end

  	context "with a parameter" do


  		# TODO refactor test
	  	subject {FunnyRecord.new(1) }

	  	it "sets the host class" do
				expect(FunnyRecord.host_class).to eq Team  		
	  	end

			it "responds to all attributes of host_class" do
				attributes = [ 'name', 'points', 'ranking', 'goals']
				attributes.each do |attribute|
					expect(subject).to respond_to(attribute)
				end
			end

	  end

	  context "without a parameter" do

	  	it "returns the host_class" do
				expect(FunnyRecord.host_class).to eq Team
	  	end

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

			it "responds <attribute>? of corresponding AR Class" do
				Team.attribute_names.each do |attribute|
					expect(subject).to respond_to("#{attribute}?")
				end
			end

			#
			# Checks a bug
			it "leaves attribute_names of host class intact"


	end

	describe "action method on class" do
		pending
	end


	describe ".find" do

		subject {TeamPage.find(record_number, selector, filter) }
		let(:selector) { ""}
		let(:filter) {""}

		context "find without an id" do
			pending
		end

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

	describe "#...? " do

		subject {TeamPage.find(1)}

		context "attribute is on page" do

			it "returns the dom object" do
				expect( subject.name?.class).to eq Capybara::Node::Element
			end
		end

		context "attribute not on page" do

			it "raises error PageRecord::AttributeNotFound" do
				expect{subject.goals?}.to raise_error(PageRecord::AttributeNotFound)
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

	describe "#... valid attribute setter" do

		subject {record.name = 'FC Utrecht'}
		let(:record) { TeamPage.find(1)}


		context "attribute is an input field" do
	  	include_context "page one record in a form"

			it "sets the attribute to specified value" do
				expect{subject}.to change{record.name}.from(nil).to('FC Utrecht')
			end
		end

		context "attribute is an input field" do
	  	include_context "page one record"

			it "raises error PageRecord::NotInputField" do
				expect{subject}.to raise_error(PageRecord::NotInputField)
			end

		end

	end

	describe "#... action methods" do

		let(:record) { TeamPage.find(1)}
  	include_context "page one record in a form"

		context "action exists on page" do
			subject {record.create}

			it "clicks on the specified action element" do
				expect{subject}.not_to raise_error(PageRecord::NotInputField) # TODO can we make it better?
			end


		end

		context "action doesn't exist on page" do
			subject {record.unkown}

			it "raises error NoMethodError" do
				expect{subject}.to raise_error(NoMethodError)
			end
		end


	end

	describe "#...? action methods" do
		pending
	end

	describe ".attributes" do
		pending
	end

	describe "found bugs" do

		describe "class name contains word page but doens't exist" do

			it "doesn'throw exception" do
				expect { class RubbishPage < PageRecord::Base; end }.not_to raise_error
			end

		end


	end


end