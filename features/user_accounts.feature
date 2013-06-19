Feature: User Accounts
  In order to track their currency collection separate from others'
  A user
  wants to have their own user account.

  @focus
  Scenario: Sign up
    Given I am signed out
    When I sign up
    Then I should have a user account

