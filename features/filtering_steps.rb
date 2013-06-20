When(/^I filter for "(.*?)"$/) do |filter_string|
  fill_in "Filter", with: filter_string
end
