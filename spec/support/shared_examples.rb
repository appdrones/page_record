shared_examples "a valid single record finder" do
  #
  # This shared example uses the following parameters
  # no_records_url
  # single_record_url
  # multiple_records_url
  #

  context "no records on the page" do
    before do
      visit no_records_url
    end

    it "raises error PageRecord::RecordNotFound" do
      expect { subject }.to raise_error(PageRecord::RecordNotFound)
    end
  end

  context "one record on the page" do
    before do
      visit single_record_url
    end

    it "returns the inheriting class" do
      expect(subject.class).to eq TeamPage
    end

    it "returns the record identified by the id" do
      expect(subject.id).to eq '1'
    end

  end

  context "multiple records on the page" do
    before do
      visit multiple_records_url
    end

    it "raises error PageRecord::MultipleRecords" do
      expect { subject }.to raise_error(PageRecord::MultipleRecords)
    end

  end

end


shared_examples "valid call of .all" do

  it "returns an Array" do
    expect(subject.class).to eq Array
  end

  it "returns the inheriting class in the Array" do
    subject.each do |record|
      expect(record.class).to eq TeamPage
    end
  end

  it "returns an element for each record on the page" do
    expect(subject.count).to eq 3
  end

end

shared_examples "it handles filters" do
  context "specified record contains specified filter" do
    let(:filter) { ".champions_league" }

    it_behaves_like "a valid call of .find"

  end

  context "specified record doesn't contain specified filter" do
    let(:filter) { ".euro_league" }

    it "raises error PageRecord::RecordNotFound" do
      expect { subject }.to raise_error(PageRecord::RecordNotFound)
    end
  end
end

shared_examples "handles invalid selectors" do
  context "with an non existing selector" do

    let(:selector) { "#non-existing-table" }
    let(:filter) { "" }

    it "raises error PageRecord::RecordNotFound" do
      expect { subject }.to raise_error(PageRecord::RecordNotFound)
    end
  end

  context "with an undetermined selector" do

    let(:selector) { ".team-table" }
    let(:filter) { "" }

    it "raises error PageRecord::MultipleRecords" do
      expect { subject }.to raise_error(PageRecord::MultipleRecords)
    end

  end
end

shared_examples "a valid call of .find" do
  it "returns the inheriting class" do
    expect(subject.class).to eq TeamPage
  end

  it "returns the record identified by the id" do
    expect(subject.id).to eq '1'
  end
end

shared_examples "a valid action finder" do
  #
  # Use the parameters:
  # valid_action
  # invalid_action
  # multiple_action
  #

  context "action exists on page" do
    subject { valid_action }
    it "clicks on the specified action element" do
      expect { subject }.not_to raise_error
    end

  end

  context "action doesn't exist on page" do
    subject { invalid_action }

    it "raises error NoMethodError" do
      expect { subject }.to raise_error(NoMethodError)
    end
  end

  context "multiple actions exist on page" do
    subject { multiple_actions }

    it "raises error PageRecord::MultipleRecords" do
      expect { subject }.to raise_error(PageRecord::MultipleRecords)
    end
  end


end
