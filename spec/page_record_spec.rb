require_relative  './spec_helper'


describe PageRecord::PageRecord do

	before do
	  class TeamRecord < PageRecord::PageRecord; end
		TeamRecord.page = single_table
	end


  let :single_table do
    Capybara.string <<-STRING
    	<table>
    		<tr data-team-id='1'>
    			<td data-attribute-for='ranking'>1</td>
    			<td data-attribute-for='name'>Ajax</td>
    			<td data-attribute-for='points'>10</td>
  			</tr>
    		<tr data-team-id='2'>
    			<td data-attribute-for='ranking'>2</td>
    			<td data-attribute-for='name'>PSV</td>
    			<td data-attribute-for='points'>8</td>
  			</tr>
    		<tr data-team-id='3'>
    			<td data-attribute-for='ranking'>3</td>
    			<td data-attribute-for='name'>Feijenoord</td>
    			<td data-attribute-for='points'>6</td>
  			</tr>
			</table>
      STRING
  end

  describe ".page=" do

  	before do
  		TeamRecord.page = nil # reset for the spec
  	end

  	subject {TeamRecord.page = single_table }

  	it "sets the page" do
			expect{subject}.to change{TeamRecord.page}.from(nil).to(single_table)  		
  	end
  end

  describe ".page" do

  	subject {TeamRecord.page}

  	it "gets the page" do
			expect(subject).to eq single_table  		
  	end
  end


	describe ".all" do
		subject {TeamRecord.all }

		context "Page contains records" do

			it "returns an Array" do
				expect(subject.class).to eq Array
			end

			it "returns the inheriting class in the Array" do
				subject.each do |record|
					expect( record.class).to eq TeamRecord
				end
			end

			it "returns an element for each record on the page" do
				expect( subject.count).to eq 3
			end

		end

		context "Page contains no records" do

			before do
				TeamRecord.page = empty_table
			end

		  let :empty_table do
	  	  Capybara.string <<-STRING
	    	<table>
	    	</table
	    	STRING
	    end

			it "returns an empty Array" do
				expect(subject).to eq []
			end

		end

	end	


	describe "inherited class" do

		subject {TeamRecord.new(1) }

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

		subject {TeamRecord.find(record_number) }

		context "one found on the page" do
			let(:record_number) { 1}

			it "returns the inheriting class" do
				expect(subject.class).to eq TeamRecord
			end

			it "returns the record identified by the id" do
				expect(subject.id).to eq 1
			end

		end

		context "multiple record found on the page" do

			let(:record_number) { 1}

			before do
				TeamRecord.page = Capybara.string <<-STRING
		    	<table>
		    		<tr data-team-id='1'>
		  			</tr>
		    		<tr data-team-id='1'>
		  			</tr>
					</table>
		      STRING
			end

			subject {TeamRecord.find(1) }

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


	end	

	describe "find_by..." do

		subject { TeamRecord.find_by_name(name)}

		context "no record on page" do
			let(:name) {"unknown name"}

			it "raises error PageRecord::RecordNotFound" do
				expect{subject}.to raise_error(PageRecord::RecordNotFound)
			end

		end

		context "multiple records on page" do
			let(:name) {"Ajax"}

			before do
				TeamRecord.page = Capybara.string <<-STRING
		    	<table>
		    		<tr data-team-id='1'>
		    			<td data-attribute-for='name'>Ajax</td>
		  			</tr>
		    		<tr data-team-id='1'>
		    			<td data-attribute-for='name'>Ajax</td>
		  			</tr>
					</table>
		      STRING
			end

			it "raises error PageRecord::MultipleRecords" do
				expect{subject}.to raise_error(PageRecord::MultipleRecords)
			end

		end

		context "one record on page" do
			let(:name) {"Ajax"}

			it "returns the inheriting class" do
				expect(subject.class).to eq TeamRecord
			end

			it "returns the record identified by the attribute" do
				expect(subject.id).to eq '1'
			end

		end


	end

	describe "#..._raw " do

		subject {TeamRecord.find(1)}

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

		subject {TeamRecord.find(1)}

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