Feature: Assign Shifts
  As an administrator
  I want to add shifts to student calendars
  So that they can see their work hours in one place

Background: Users created
  Given the following users exist:
    | name    | type       |
    | Chris   | admin      |
    | Alice   | standard   |
  And I am logged in as “Chris”
  Scenario: Assign a shift
    Given I am on the calendar page for “Alice”
    When I select the interval “12:00 1/1/2012” to “2:00 1/1/2012“
    And I set "Name" to be "Performance Review"
    And I press "submit"
    Then I should be on the calendar page for "Alice"
    And I should see "Performance Review"