require_relative  './spec_helper'

describe PageRecord::Base do

  include_context "default context"
  include_context "page one record in a form"

  describe ".type" do

    before do
      class CamelCase
        def self.attribute_names
          %w(id name points ranking goals)
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
        expect(CamelCasePage.type).to eq "camel_case"
      end
    end

    context "a type given" do

      before do
        class CamelCasePage < PageRecord::Base
          type :team
        end
      end

      it "sets the internal type of the class" do
        expect(CamelCasePage.type).to eq :team
      end
    end

  end

  describe ".attributes" do

    context "no parameter given" do

      it "returns all current recognised attributes" do
        expect(TeamPage.attributes).to eq %w(name points ranking goals)
      end
    end

    context "parameter given" do

      subject { TeamPage }

      before do
        class TeamPage < PageRecord::Base
          attributes %w(country stadium)
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
        expect(TeamPage.attributes).to eq %w(country stadium)
      end
    end

  end

  describe ".add_attributes" do
    before do
      class TeamPage < PageRecord::Base
        add_attributes %w(country stadium)
      end
    end

    subject { TeamPage }

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
      expect(subject.add_attributes ['more']).to eq %w(name points ranking goals country stadium more)
    end

  end

  describe ".page" do

    context "with a parameter" do
      let(:test_page) { Object.new }
      subject { PageRecord::Base.page test_page }

      it "sets the page when called on PageRecord::Base" do
        expect { subject }.to change { PageRecord::Base.page }.to(test_page)
      end

      it "sets the page when called on subclass" do
        expect { TeamPage.page test_page }.to change { PageRecord::Base.page }.to(test_page)
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

      # TODO: refactor test
      subject { FunnyRecord.new(1) }

      it "sets the host class" do
        expect(FunnyRecord.host_class).to eq Team
      end

      it "responds to all attributes of host_class" do
        attributes = %w(name points ranking goals)
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

  describe "inherited class" do

    subject { TeamPage.new(1) }

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

  end

  describe "record.element?" do

    subject { TeamPage.find().element? }

    context "record on the page" do
      before do
        visit '/page-one-record'
      end

      it "returns the capybara element containing the record" do
        expect(subject.class).to eq Capybara::Node::Element
      end

    end
  end


  describe "found bugs" do

    describe "class name contains word page but doens't exist" do

      it "doesn'throw exception" do
        expect { class RubbishPage < PageRecord::Base; end }.not_to raise_error
      end

    end

  end

end
# rubocop:enable StringLiterals
