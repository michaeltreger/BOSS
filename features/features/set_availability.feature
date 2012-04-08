Feature: Set Availability Calendar
  As a student
  I want to put my available times online
  So that I will be scheduled to work at the most convenient times
Background: Logged in as student
  Given the following users exist:
    | name     | type       |
    | Alice    | standard   |
  And I am logged in as "Alice”
  Scenario: Add an obligation to my Availability Calendar
    Given I am on my Availability page
    When I select the interval “11:00 1/1/2012” to “15:00 1/1/2012“
    And I set "Name" to be "Classes"
    And I press "submit"
    Then I should be on my Availability page
    And I should see "Classes"  