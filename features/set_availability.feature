Feature: Set Availability Calendar
  As a student
  I want to put my available times online
  So that I will be scheduled to work at the most convenient times

Background: A Calendar has been created
  Given the following users exist:
    | name         | user_type      |
    | Alice        | 1              |
    | Joe          | 0              |


  And I am logged in as "Alice"

  And the following calendars exist:
    | name             | calendar_type  | user_id |
    | Alice's Calendar | 1              | 1       |

  And the calendar "Alice's Calendar" has the following entries:
    | description         | start_time        | end_time         | type       |
    | Work at Wheeler     | 12:00, 1/1/2012   | 14:00 1/1/2012   | prefer     |
    | Software Training   | 14:00, 1/1/2012   | 16:00 1/1/2012   | rather_not |

  Scenario: Add a class to my Availability Calendar  
    When I am on Alice's Calendar page
    And I select the interval "11:00, 1/1/2012" to "15:00, 1/1/2012" as "class"
    When I view the calendar
    Then I should see "class"

