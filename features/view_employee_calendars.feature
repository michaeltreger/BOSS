Feature: View Students Calendars
  As an administrator
  I want to view the student’s uploaded calendars
  So that I can assign schedules to students

Background: A Calendar has been created
  Given the following users exist:
    | name         | user_type      |
    | Alice        | 1              |
    | Chris        | o              |

  And I am logged in as "Chris"

  And the following calendars exist:
    | name             | calendar_type  | user_id |
    | Alice's Calendar | 1              | 1       |

  And the calendar "Alice's Calendar" has the following entries:
    | description         | start_time        | end_time         | entry_type |
    | Soccer Practice     | 12:00, 1/1/2012   | 14:00 1/1/2012   | obligation |
    |                     | 14:00, 1/1/2012   | 16:00 1/1/2012   | rather_not |


  Scenario: View Alice's Availability Calendar
    Given I am on Alice's Calendar page
    And I view the calendar
    Then I should see "obligation"
    And I should see "Soccer Practice"
    And I should see "rather_not"

