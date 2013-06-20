Feature: Manage countries
  In order to manage his travel itinerary
  Mr. Smart
  wants to manage the countries he has visited.

  Background:
    Given I am signed in

  Scenario: List Countries
    Given the following countries exist:
      | name         | code |
      | CountryOne   | c1   |
      | CountryTwo   | c2   |
      | CountryThree | c3   |
      | CountryFour  | c4   |
      | CountryFive  | c5   |
    And I have visited the following countries:
      | name         |
      | CountryThree |
      | CountryFour  |
      | CountryFive  |
    And I am on the countries page
    Then I should see the following table:
      | Name         | Code | Status      |
      | CountryOne   | c1   | Not Visited |
      | CountryTwo   | c2   | Not Visited |
      | CountryThree | c3   | Visited     |
      | CountryFour  | c4   | Visited     |
      | CountryFive  | c5   | Visited     |

  Scenario: See whether I've visited a Country
    Given I have visited a country named "Rhovanion"
    When I am on the country page for "Rhovanion"
    Then I should see "Status: Visited"

  Scenario: Visit Country via show
    Given I am on a country page
    When I follow "Visit"
    Then I should see "Status: Visited"

  @focus
  Scenario: Visit Country via index
    Given a country exists
    And I am on the countries page
    When I follow "Visit"
    Then I should see "Status: Visited"
