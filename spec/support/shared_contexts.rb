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

shared_context "page without errors" do
  before do
    visit "/page-without-errors"
  end
end

shared_context "page with 1 error" do
  before do
    visit "/page-with-1-error"
  end
end

shared_context "page with 2 errors on same attribute" do
  before do
    visit "/page-with-2-errors-on-same-attribute"
  end
end

shared_context "page with 2 errors on different attributes" do
  before do
    visit "/page-with-2-errors-on-different-attributes"
  end
end


shared_context "default context" do

  before do
    class TeamPage < PageRecord::Base; end
    PageRecord::Base.page page
  end

  after do
    Object.send(:remove_const, :TeamPage)
  end

end
