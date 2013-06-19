When(/^I sign up$/) do
  visit root_path
  click_on 'Sign Up'
  fill_in 'Email', with: 'example@example.com'
  fill_in 'Password', with: 'password'
  fill_in 'Password confirmation', with: 'password'
  click_on 'Sign up'
end

Then(/^I should have a user account$/) do
  assert_equal(1, User.count)
end
