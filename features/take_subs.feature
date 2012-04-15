Feature: Take Shifts
  As a student
  I want to take substitutions from other students
  So that I can add shifts to my schedule
Background: Substitutions created
  Given the following users exist:
    | name         | user_type      | initials  |
    | Alice        | 1              |   AA      |
    | Bob          | 1              |   BB      |
    | Carl         | 1              |   CC      |
    | David        | 0              |   DD      |

  And I am logged in as “Alice”

  And the following calendars exist:
    | name             | calendar_type  | user_id |
    | Alice's Calendar |   1            |   1     |
    | Bob's Calendar   |   1            |   2     |

  And the calendar "Alice's Calendar" has the following entries:
    | description         | start_time        | end_time         |
    | Work at Wheeler     | 12:00, 1/1/2012   | 14:00 1/1/2012   |
    | Software Training   | 14:00, 1/1/2012   | 16:00 1/1/2012   |


  And the calendar "Bob's Calendar" has the following entries:
    | description         | start_time        | end_time         |
    | Work at Moffit      | 15:00, 1/1/2012   | 18:00 1/1/2012   |
    | Presentation        | 8:00, 1/1/2012    | 12:00 1/1/2012   |


  And the following substitutions exist:
    | entry_id   | description           | from_user_id    | to_user_id |
    |   1        | Work at Moffit        |    2            |    1       |
    |   2        | Presentation          |    2            |            |


  Given I am on the "View Substitutions" page
  Scenario: Take available substitutions
    When I check "Work at Moffit"
    And I check "Presentation"
    And I click "Take Selected Substitutions"
    And I am on Alice's Calendar page
    And I view the calendar
    Then I should see "Work at Moffit"
    And I should see "Presentation"

  Scenario: Taken substitutions are no longer available
    And I check "Presentation"
    And I click "Take Selected Substitutions"
    And I go to the "View Substitutions" page
    Then I should not see "Presentation"
    And I should see "Work at Moffit"