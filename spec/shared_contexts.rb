shared_context "page with single table with 3 records" do
  let :page do
    Capybara.string <<-STRING
    	<table>
    		<tr data-team-id='1' class='champions_league'>
    			<td data-attribute-for='ranking'>1</td>
    			<td data-attribute-for='name'>Ajax</td>
    			<td data-attribute-for='points'>10</td>
  			</tr>
    		<tr data-team-id='2' class='champions_league'>
    			<td data-attribute-for='ranking'>2</td>
    			<td data-attribute-for='name'>PSV</td>
    			<td data-attribute-for='points'>8</td>
  			</tr>
    		<tr data-team-id='3'>
    			<td data-attribute-for='ranking'>3</td>
    			<td data-attribute-for='name'>Feijenoord</td>
    			<td data-attribute-for='points'>6</td>
  			</tr>
			</table>
      STRING
  end
end

shared_context "page with two tables with 3 records" do
  let :page do
    Capybara.string <<-STRING
      <div class='team-table'>
        <table id='first-table'>
          <tr data-team-id='1' class='champions_league'>
            <td data-attribute-for='ranking'>1</td>
            <td data-attribute-for='name'>Ajax</td>
            <td data-attribute-for='points'>10</td>
          </tr>
          <tr data-team-id='2' class='champions_league'>
            <td data-attribute-for='ranking'>2</td>
            <td data-attribute-for='name'>PSV</td>
            <td data-attribute-for='points'>8</td>
          </tr>
          <tr data-team-id='3' class='euro_league'>
            <td data-attribute-for='ranking'>3</td>
            <td data-attribute-for='name'>Feijenoord</td>
            <td data-attribute-for='points'>6</td>
          </tr>
        </table>
      </div>
      <div class='team-table'>
        <table id='second-table'>
          <tr data-team-id='1' class='champions_league'>
            <td data-attribute-for='ranking'>1</td>
            <td data-attribute-for='name'>Ajax</td>
            <td data-attribute-for='points'>10</td>
          </tr>
          <tr data-team-id='2' class='champions_league'>
            <td data-attribute-for='ranking'>2</td>
            <td data-attribute-for='name'>PSV</td>
            <td data-attribute-for='points'>8</td>
          </tr>
          <tr data-team-id='3' class='euro_league'>
            <td data-attribute-for='ranking'>3</td>
            <td data-attribute-for='name'>Feijenoord</td>
            <td data-attribute-for='points'>6</td>
          </tr>
        </table>
      </div>
      STRING
  end
end



shared_context "page without records" do
  let :page do
    Capybara.string <<-STRING
    <table>
    </table
    STRING
  end
end

shared_context "page with duplicate records" do
  let :page do
    Capybara.string <<-STRING
      <table>
        <tr data-team-id='1'>
          <td data-attribute-for='name'>Ajax</td>
        </tr>
        <tr data-team-id='1'>
          <td data-attribute-for='name'>Ajax</td>
        </tr>
      </table>
      STRING
  end
end

shared_context "page one record in a form" do
  let :page do
    Capybara.string <<-STRING
    <form data-team-id='1'>
        <input data-attribute-for='name'>
    </form>
      STRING
  end
end


shared_context "page one record" do
  let :page do
    Capybara.string <<-STRING
    <div data-team-id='1'>
        <div data-attribute-for='name'></div>
    </div>
      STRING
  end
end
