require_relative  './spec_helper'

describe PageRecord::Attributes do

  include_context "default context"

  describe "#... valid attribute getter" do

    subject { TeamPage.find(1) }
    include_context "page with single table with 3 records"

    context "attribute is on page" do

      it "returns a the value on the page" do
        expect(subject.name).to eq 'Ajax'
      end
    end

    context "attribute not on page" do

      it "raises error PageRecord::AttributeNotFound" do
        expect { subject.goals }.to raise_error(PageRecord::AttributeNotFound)
      end

    end

  end

  describe "#... valid attribute setter" do

    subject { record.name = 'FC Utrecht' }
    let(:record) { TeamPage.find(1) }

    context "attribute is an input field" do
      include_context "page one record in a form"

      it "sets the attribute to specified value" do
        expect { subject }.to change { record.name }.from(nil).to('FC Utrecht')
      end
    end

    context "attribute is an input field" do
      include_context "page one record"

      it "raises error PageRecord::NotInputField" do
        expect { subject }.to raise_error(PageRecord::NotInputField)
      end

    end

  end

  describe "#...? " do

    subject { TeamPage.find(1) }

    context "attribute is on page" do

      it "returns the dom object" do
        expect(subject.name?.class).to eq Capybara::Node::Element
      end
    end

    context "attribute not on page" do

      it "raises error PageRecord::AttributeNotFound" do
        expect { subject.goals? }.to raise_error(PageRecord::AttributeNotFound)
      end

    end
  end

end
