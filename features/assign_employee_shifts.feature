Feature: Assign Shifts
  As an administrator
  I want to add shifts to student calendars
  So that they can see their work hours in one place

Background: Users created
  Given the following users exist:
    | name         | user_type      |
    | Alice        | 1              |
    | Bob          | 1              |
    | Chris        | 0              |

  And the following periods exist:
    | name             |
    | Finals Week 1    |


  And the calendar "Alice's Shifts" has the following entries:
    | description         | start_time        | end_time         | entry_type |
    | Soccer Practice     | 12:00, 1/1/2012   | 14:00 1/1/2012   | obligation |
    |                     | 14:00, 1/1/2012   | 16:00 1/1/2012   | rather_not |
    | Class               | 16:00, 1/1/2012   | 17:00 1/1/2012   | class      |


  Scenario: Assign a shift
    Given I am logged in as "Chris"
    And I am on Alice's Shifts page
    When I select the interval “12:00 1/1/2012” to “2:00 1/1/2012“
    And I set "Name" to be "Performance Review"
    And I press "submit"
    Then I should be on the calendar page for "Alice"
    And I should see "Performance Review"

  Scenario: Violate employee restrictions
    Given I am logged in as "Chris"
    And I am on Alice's Shifts page
    When I select the interval “16:00 1/1/2012” to “17:00 1/1/2012“
    And I set "Name" to be "Performance Review"
    And I press "submit"
    Then I should be on the calendar page for "Alice"
    And I should see "The time inteval you set is not allowed"
