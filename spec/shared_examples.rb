shared_examples "valid call of .all" do

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

shared_examples "handles invalid selectors" do
	context "with an non existing selector" do

		let(:selector)	{"#non-existing-table"}

		it "raises error PageRecord::RecordNotFound" do
			expect{subject}.to raise_error(PageRecord::RecordNotFound)
		end
	end

	context "with an undetermined selector" do

		let(:selector)	{".team-table"}

		it "raises error PageRecord::MultipleRecords" do
			expect{subject}.to raise_error(PageRecord::MultipleRecords)
		end

	end
end

shared_examples "a valid call of .find" do
	it "returns the inheriting class" do
		expect(subject.class).to eq TeamRecord
	end

	it "returns the record identified by the id" do
		expect(subject.id).to eq '1'
	end
end
