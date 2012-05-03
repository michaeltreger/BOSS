Feature: Set Availability Calendar
  As a student
  I want to put my available times online
  So that I will be scheduled to work at the most convenient times

Background: A Calendar has been created
  Given the following users exist:
    | name         | user_type      |
    | Alice        | 1              |
    | Joe          | 0              |

  And the following periods exist:
    | name             |
    | Finals Week 1    |

  And I am logged in as "Alice"

  And the calendar "Alice's Finals Week 1 Availabilities" has the following entries:
    | description         | start_time        | end_time         | type       |
    | Work at Wheeler     | 12:00, 1/1/2012   | 14:00 1/1/2012   | prefer     |
    | Software Training   | 14:00, 1/1/2012   | 16:00 1/1/2012   | rather_not |

  Scenario: Add a class to my Availability Calendar  
    When I am on Alice's Availability Calendar for "Finals Week 1"
    And I select the interval "11:00, 1/1/2012" to "15:00, 1/1/2012" as "class"
    When I view the calendar
    Then I should see "class"

