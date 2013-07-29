require_relative  './spec_helper'

describe PageRecord::Actions do

  include_context "default context"
  describe "#... action methods" do

    let(:record) { TeamPage.find(1) }
    include_context "page one record in a form"

    context "action exists on page" do
      subject { record.create }

      it "clicks on the specified action element" do
        expect { subject }.not_to raise_error
      end

    end

    context "action doesn't exist on page" do
      subject { record.unkown }

      it "raises error NoMethodError" do
        expect { subject }.to raise_error(NoMethodError)
      end
    end

  end

  describe "#...? action methods" do
    pending
  end

  describe "action method on class" do
    pending
  end

end