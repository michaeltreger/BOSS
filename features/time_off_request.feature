Feature: Time-off Request
  As a student
  I want to make a time-off request
  So that I don't need to work for that time interval

Background: Users created
  Given the following users exist:
    | name         | user_type      |
    | Alice        | 1              |
    | Bob          | 1              |
    | Chris        | 0              |

  And the following calendars exist:
    | name             | calendar_type  | user_id |
    | Alice's Calendar | 1              | 1       |

  And the calendar "Alice's Calendar" has the following entries:
    | description         | start_time        | end_time         | entry_type |
    | Soccer Practice     | 12:00, 1/1/2012   | 14:00 1/1/2012   | obligation |
    |                     | 14:00, 1/1/2012   | 16:00 1/1/2012   | rather_not |

  And the following time-off requests for Alice exist:
    | request_id | start           | end              | days notice | reason      |
    |    1       | 12:00, 1/1/2012 | 16:00, 1/1/2012  | 3           | go shopping |

  Scenario: Make a time-off request
    Given I am logged in as "Alice"
    And I am on Alice's time-off requests page
    And I should see a request start at 12:00, 1/1/2012 and end at 16:00, 1/1/2012 
    And I press "Make a new request"
    Then I should be on the Create New Request page
    When I fill in "start time" with "10:00, 1/2/2012"
    And I fill in "end time" with "12:00, 1/2/2012"
    And I fill in "reason" with "go shopping"
    And I press "Save Changes"
    Then I should be on Alice's time-off requests page
    And I should see a request start at 10:00, 1/2/2012 and end at 12:00, 1/2/2012


  Scenario: Delete a time-off request
    Given I am logged in as "Alice"
    And I am on Alice's time-off reuqests page
    When I press delete for a request start at 12:00, 1/1/2012 and end at 16:00, 1/1/2012
    Then I should be on Alice's time-off requests page
    And I should not see a request start at 12:00, 1/1/2012 and end at 16:00, 1/1/2012

