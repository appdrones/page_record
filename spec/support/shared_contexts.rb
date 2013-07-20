shared_context "page with single table with 3 records" do
  before do
    visit "/page-with-single-table-with-3-records"
  end
end

shared_context "page with two tables with 3 records" do
  before do
    visit "/page-with-two-tables-with-3-records"
  end
end

shared_context "page without records" do
  before do
    visit "/page-without-records"
  end
end

shared_context "page with duplicate records" do
  before do
    visit "/page-with-duplicate-records"
  end
end

shared_context "page one record in a form" do
  before do
    visit "/page-one-record-in-a-form"
  end
end

shared_context "page one record" do
  before do
    visit "/page-one-record"
  end
end
