Feature: Assign a Substitution
  As an admin
  I want to assign substitutions to students
  so that I can ensure important shifts are filled

Background: Substitutions created
  Given the following users exist:
    | name         | user_type      | initials  |
    | Alice        | 1              |   AA      |
    | Bob          | 1              |   BB      |
    | Carl         | 1              |   CC      |
    | David        | 0              |   DD      |

  And I am logged in as “David”

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
    |   1        | Work at Moffit        |    2            |    3       |
    |   2        | Presentation          |    2            |            |

  Given I am on the "View Substitutions" page

  Scenario: Admins can assign substitutions
    Then I should see "Assign Selected Substitutions"

  Scenario: Non-admins cannot assign substitutions
    When I am logged in as "Alice"
    And I am on the "View Substitutions" page
    Then I should not see "Assign Selected Substitutions"
  

  Scenario: Assign a reserved substitution to somebody
    When I check "Work at Moffit"
    And I assign the substitution to the user with initials "AA"
    And I click "Assign Selected Substitutions"
    And I am on Alice's Calendar page
    And I view the calendar
    Then I should see "Work at Moffit"

  Scenario: Assign an open substitution to somebody
    When I check "Presentation"
    And I assign the substitution to the user with initials "AA"
    And I click "Assign Selected Substitutions"
    And I am on Alice's Calendar page
    And I view the calendar
    Then I should see "Work at Moffit"

  Scenario: Assigned substitutions are no longer available
    When I check "Work at Moffit"
    And I assign the substitution to the user with initials "AA"
    And I click "Assign Selected Substitutions"
    And I go the "View Substitutions" page
    Then I should see "Presentation"
    And I should not see "Work at Moffit"