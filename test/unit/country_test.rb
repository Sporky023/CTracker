require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  test_validates_presence_of :name, :code

  test "when visited by one user, not visited by another user" do
    country = FactoryGirl.create(:country)
    one_user = FactoryGirl.create(:user)
    visit = FactoryGirl.create(:visit, user: one_user, country: country)

    another_user = FactoryGirl.create(:user)
    assert_equal(false, country.visited_by_user?(another_user))
  end

end
