require_relative  './spec_helper'

describe PageRecord::Finders do

  include_context "default context"

  describe ".all" do

    include_context "page with single table with 3 records"
    subject { TeamPage.all(selector, filter) }

    context "one set of records available on the page" do
      let(:selector) { "" }
      let(:filter) { "" }

      it_behaves_like "valid call of .all"

      context "with a filter" do
        let(:filter) { ".champions_league" }

        it "returns only the elements that contain the filter css" do
          expect(subject.map { |c| c.name }).not_to include('Feijenoord')
          expect(subject.map { |c| c.name }).to include(*%w(Ajax PSV))
        end
      end

    end

    context "No records available on the page" do

      include_context "page without records"
      let(:selector) { "" }
      let(:filter) { "" }

      it "is empty" do
        expect(subject).to be_empty
      end

    end

    context "multiple sets of records avialable on the page" do
      include_context "page with two tables with 3 records"

      context "without selector" do
        let(:selector) { "" }
        let(:filter) { "" }

        it "raises error PageRecord::MultipleRecords" do
          expect { subject }.to raise_error(PageRecord::MultipleRecords)
        end

      end

      it_behaves_like "handles invalid selectors"

      context "with a correct selector" do

        let(:selector) { "#first-table" }
        let(:filter) { "" }

        it_behaves_like "valid call of .all"

      end

    end
  end

 describe ".find" do

    context "no selector no filter" do

      context "id given" do
        subject { TeamPage.find(1) }
        it_behaves_like "a valid single record finder" do
          let(:no_records_url)        { '/page-without-records' }
          let(:single_record_url)     { '/page-one-record' }
          let(:multiple_records_url)  { '/page-with-duplicate-records' }
        end
      end

      context "no id given" do
        subject { TeamPage.find }
        it_behaves_like "a valid single record finder" do
          let(:no_records_url)        { '/page-without-records' }
          let(:single_record_url)     { '/page-one-record' }
          let(:multiple_records_url)  { '/page-with-duplicate-records' }
        end
      end
    end

    context "with selector" do
      subject { TeamPage.find(1, '.the-selector', '') }
      it_behaves_like "a valid single record finder" do
        let(:no_records_url)        { '/page-without-records-with-selector' }
        let(:single_record_url)     { '/page-one-record-with-selector' }
        let(:multiple_records_url)  { '/page-with-duplicate-records-with-selector' }
      end
    end

    context "with filter" do
      subject { TeamPage.find(1, '', '.the-filter') }
      it_behaves_like "a valid single record finder" do
        let(:no_records_url)        { '/page-without-records-with-filter' }
        let(:single_record_url)     { '/page-one-record-with-filter' }
        let(:multiple_records_url)  { '/page-with-duplicate-records-with-filter' }
      end
    end
  end

  describe ".find_by_...." do

    context "no selector no filter" do

      context "id given" do
        subject { TeamPage.find_by_name('Ajax') }
        it_behaves_like "a valid single record finder" do
          let(:no_records_url)        { '/page-without-records' }
          let(:single_record_url)     { '/page-one-record' }
          let(:multiple_records_url)  { '/page-with-duplicate-records' }
        end
      end
    end

    context "with selector" do
      subject { TeamPage.find_by_name('Ajax', '.the-selector', '') }
      it_behaves_like "a valid single record finder" do
        let(:no_records_url)        { '/page-without-records-with-selector' }
        let(:single_record_url)     { '/page-one-record-with-selector' }
        let(:multiple_records_url)  { '/page-with-duplicate-records-with-selector' }
      end
    end

    context "with filter" do
      subject { TeamPage.find_by_name('Ajax', '', '.the-filter') }
      it_behaves_like "a valid single record finder" do
        let(:no_records_url)        { '/page-without-records-with-filter' }
        let(:single_record_url)     { '/page-one-record-with-filter' }
        let(:multiple_records_url)  { '/page-with-duplicate-records-with-filter' }
      end
    end
  end



end

