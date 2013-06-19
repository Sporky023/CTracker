Given /the following countries exist:/ do |countries|
  Country.create!(countries.hashes)
end

Given(/^I have visited the following countries:$/) do |countries|
  countries.hashes.map{|x| x['name']}.each do |country_name|
    country = Country.find_by_name(country_name)
    Visit.create!(
      user: @user,
      country: country
    )
  end
end

Then /^I should see the following table:$/ do |expected_table|
  document = Nokogiri::HTML(page.body)
  rows = document.css('section>table>tr').collect { |row| row.xpath('.//th|td').collect {|cell| cell.text } }

  expected_table.diff!(rows)
end
