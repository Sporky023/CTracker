require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
  test_validates_presence_of :name, :code

  test "when collected by one user, not collected by another user" do
    currency = FactoryGirl.create(:currency)
    one_user = FactoryGirl.create(:user)
    visit = FactoryGirl.create(:visit, user: one_user, country: currency.country)

    another_user = FactoryGirl.create(:user)
    assert_equal(false, currency.collected_by_user?(another_user))
  end
end
