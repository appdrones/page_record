require_relative  './spec_helper'

describe PageRecord::Actions do

  include_context "default context"

  describe "#<action>" do

    let(:record) { TeamPage.find(1) }
    include_context "page one record in a form"

    before do
      Capybara::Node::Element.any_instance.
          stub(:click). # TODO: Find out why should_receive doesn't work
          and_return('OK')
    end


    it_behaves_like "a valid action finder" do
      let(:valid_action) { record.create}
      let(:invalid_action) { record.unkown_action }
      let(:multiple_actions) { record.multiple_action }
    end
  end

  describe "#<action>?" do

    let(:record) { TeamPage.find(1) }
    include_context "page one record in a form"

    it_behaves_like "a valid action finder" do
      let(:valid_action) { record.create?}
      let(:invalid_action) { record.unkown_action?}
      let(:multiple_actions) { record.multiple_action? }
    end
  end

  describe ".<action>" do
    include_context "page one record in a form"

    before do
      Capybara::Node::Element.any_instance.
          stub(:click). # TODO: Find out why should_receive doesn't work
          and_return('OK')
    end


    it_behaves_like "a valid action finder" do
      let(:valid_action) { TeamPage.page_action}
      let(:invalid_action) { TeamPage.unkown_action}
      let(:multiple_actions) { TeamPage.multiple_action }
    end
  end

  describe ".<action>?" do
    include_context "page one record in a form"

    it_behaves_like "a valid action finder" do
      let(:valid_action) { TeamPage.page_action?}
      let(:invalid_action) { TeamPage.unkown_action?}
      let(:multiple_actions) { TeamPage.multiple_action?}
    end
  end

end