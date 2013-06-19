Given(/^I am signed out$/) do
  Capybara.reset_sessions!
end

When(/^I sign in$/) do
  visit root_path
  click_on 'Sign In'
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_on 'Sign in'
end

Then(/^I should be signed in$/) do
  page.should have_content("Signed in")
end
