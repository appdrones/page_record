require_relative  './spec_helper'

describe PageRecord::Validations do

  include_context "default context"

  let(:record) { TeamPage.find}

  describe '#errors' do

  	subject {record.errors}


  	context "No errors on the page" do

      include_context "page without errors"

  		it "is empty" do
  			expect(subject).to be_empty
	  	end
	  end

	  context "1 error on the page" do
      include_context "page with 1 error"

  		it "returns an Error object with the atrribute and error" do
  			expect(subject[:name]).to eq ['this is the validation message']
	  	end

	  end

	  context "more errors on the same attribute" do
      include_context "page with 2 errors on same attribute"

  		it "returns an Error object with the atrributes and errors" do
  			expect(subject[:name]).to eq ['this is the first validation message', 'this is the second validation message']
	  	end

	  end

	  context "more errors on the different attributes" do
      include_context "page with 2 errors on different attributes"

  		it "returns an Error object with the atrributes and errors" do
  			expect(subject[:name]).to eq ['this is the validation message for name']
  			expect(subject[:age]).to eq ['this is the validation message for age']
	  	end

	  end


  end

  describe '#valid?' do

  	subject { record.valid?}

  	context "No errors on the page" do
      include_context "page without errors"

      it 'is true' do
      	expect(subject).to be_true
      end
 
	  end

	  context "1 error on the page" do
      include_context "page with 1 error"

      it 'is false' do
      	expect(subject).to be_false
      end


	  end

	  context "more errors on the same attribute" do
      include_context "page with 2 errors on same attribute"

      it 'is false' do
      	expect(subject).to be_false
      end
    end

	  context "more errors on the different attributes" do
      include_context "page with 2 errors on different attributes"

      it 'is false' do
      	expect(subject).to be_false
      end

    end

  end

  describe '#invalid?' do

  	subject { record.invalid?}

  	context "No errors on the page" do
      include_context "page without errors"

      it 'is false' do
      	expect(subject).to be_false
      end
 
	  end

	  context "1 error on the page" do
      include_context "page with 1 error"

      it 'is true' do
      	expect(subject).to be_true
      end


	  end

	  context "more errors on the same attribute" do
      include_context "page with 2 errors on same attribute"

      it 'is true' do
      	expect(subject).to be_true
      end
    end

	  context "more errors on the different attributes" do
      include_context "page with 2 errors on different attributes"

      it 'is true' do
      	expect(subject).to be_true
      end

    end

  end


end
