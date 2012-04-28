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

  And I am logged in as "David"

  And the calendar "Alice's Shifts" has the following entries:
    | description         | start_time        | end_time         |
    | Work at Wheeler     | 12:00, 1/1/2012   | 14:00 1/1/2012   |
    | Software Training   | 14:00, 1/1/2012   | 16:00 1/1/2012   |


  And the calendar "Bob's Shifts" has the following entries:
    | description         | start_time        | end_time         |
    | Work at Moffit      | 15:00, 1/1/2012   | 18:00 1/1/2012   |
    | Presentation        | 8:00, 1/1/2012    | 12:00 1/1/2012   |


  And the following substitutions exist:
    | entry_id   | description           | from_user_id    | to_user_id |
    |   3        | Work at Moffit        |    2            |    3       |
    |   4        | Presentation          |    2            |    nil     |

  Given I am on the "Manage Substitutions" page

  Scenario: Admins can assign substitutions
    Then I should see "Manage Substitutions"

  Scenario: Non-admins cannot assign substitutions
    When I am logged in as "Alice"
    And I am on the "Manage Substitutions" page
    Then I should not see "Manage Substitutions"
  

  Scenario: Assign a reserved substitution to somebody
    When I check the substitution "Work at Moffit"
    And I assign the substitution to "Alice"
    And I press "Make Assignments"
    And I am on Alice's Shifts page
    And I view the calendar
    Then I should see "Work at Moffit"

  Scenario: Assign an open substitution to somebody
    When I check the substitution "Presentation"
    And I assign the substitution to "Alice"
    And I press "Make Assignments"
    And I am on Alice's Shifts page
    And I view the calendar
    Then I should see "Presentation"

  Scenario: Assigned substitutions are no longer available
    When I check the substitution "Work at Moffit"
    And I assign the substitution to "Alice"
    And I press "Make Assignments"
    And I go to the "Manage Substitutions" page
    Then I should see "Presentation"
    And I should not see "Work at Moffit"