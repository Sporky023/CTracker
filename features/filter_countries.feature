Feature: Filter Countries
  In order to quickly find countries
  Any old user
  wants to type a few letters and have it pop up by real-time filtering.

  @javascript
  Scenario: Filter some countries
    Given the following countries exist:
      | name    | code |
      | Mordor  | o1   |
      | Rohan   | o2   |
      | Eriador | e1   |
      | Gondor  | h1   |
    And I am signed in
    When I am on the countries page
    And I filter for "dor"
    Then I should see "Eriador"
    And I should see "Gondor"
    And I should not see "Rohan"
