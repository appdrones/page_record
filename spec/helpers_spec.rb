require 'action_view'
require_relative  './spec_helper'

describe "Rails helpers" do

  before(:each) do
    extend PageRecord::Helpers
    extend ActionView::Helpers
    extend ActionView::Helpers::FormHelper
    extend ActionView::Helpers::FormTagHelper
    extend ActionView::Helpers::UrlHelper
    extend ActionView::Context
    class Car; end
  end

  describe '#form_record_for' do

    context "without a variable argument" do

      subject { form_record_for(:car) }

      context "with a new record" do

        before do
          @car = stub_model(Car, id: nil)
        end

        it "returns a Hash with data-`type`-name=`new`" do
          expect(subject).to eq({ 'data-car-id' => 'new' })
        end
      end

      context "with a saved record" do

        before do
          @car = stub_model(Car, id: 10)
        end

        it "returns a Hash with data-`type`-name=id" do
          expect(subject).to eq({ 'data-car-id' => 10 })
        end
      end

    end

    context "with a variable argument" do

      subject { form_record_for(:car, other_car) }
      let(:other_car) { @other_car = stub_model(Car, id: nil) }

      context 'with a new record' do

        it "returns a Hash with data-`type`-name=`new`" do
          expect(subject).to eq({ 'data-car-id' => 'new' })
        end
      end

      context "with a saved record" do

        let(:other_car) { @other_car = stub_model(Car, id: 10) }

        it "returns a Hash with data-`type`-name=id" do
          expect(subject).to eq({ 'data-car-id' => 10 })
        end
      end

    end

  end

  describe '#attribute_for' do
    subject { attribute_for('name') }

    it "returns a Hash with data-attribute-for => 'attribute' " do
      expect(subject).to eq({ 'data-attribute-for' => 'name' })
    end

  end

  describe '#action_for' do

    context "a submit action" do

      subject { action_for('submit') }

      it "returns a Hash with data-action-for => 'save' " do
        expect(subject).to eq({ 'data-action-for' => 'save' })
      end
    end

    context "an other action" do

      subject { action_for('other') }

      it "returns a Hash with data-action-for => 'attribute' " do
        expect(subject).to eq({ 'data-action-for' => 'other' })
      end
    end


  end

  describe '#attribute_tag_for' do
    subject { attribute_tag_for(:td, :name) }

    it "returns a tag with data-attribute-for='name' set" do
      expect(subject).to eq "<td data-attribute-for=\"name\"></td>"
    end
  end

  describe '#record_form_for' do

    before do
      @car = stub_model(Car, id: 20)
      def protect_against_forgery?; end
    end

    subject { record_form_for(@car, as: :car, url: '/') {} }

    it 'returns a PageRecordFormBuilder' do
      expect(subject).to include " data-car-id=\"20\" "
    end
  end

  describe PageRecord::FormBuilder do

    before do
      @car = stub_model(Car, id: 20, name: 'Piet')
      def protect_against_forgery?; end
    end

    describe '#text_field' do
      subject do
        record_form_for(@car, as: :car, url: '/') do |f|
          f.text_field :name
        end
      end

      it "automaticaly renders the data-attribute-for='name' html-tag" do
        expect(subject).to include " data-attribute-for=\"name\" "
      end
    end

    describe '#submit' do
      subject do
        record_form_for(@car, as: :car, url: '/') do |f|
          f.submit 'Save'
        end
      end

      it "automaticaly renders the data-action-for='submit' html-tag" do
        expect(subject).to include " data-action-for=\"save\" "
      end
    end

  end

end
