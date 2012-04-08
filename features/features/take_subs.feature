Feature: Take Shifts
  As a student
  I want to take substitutions from other students
  So that I can work extra hours when I realize I am available last minute
Background: Substitutions created
  Given the following users exist:
    | name         | type      |
    | Alice        | standard  |
    | Bob          | standard  |
  And I am logged in as “Alice”

  And the following calendar entries exist:
    | name       | owner | description       | start_time        | end_time         |
    | Work       | Alice | Work at Wheeler   | 12:00, 1/1/2012   | 14:00 1/1/2012   |
    | Lab Hours  | Bob   | Software Training | 14:00, 1/1/2012   | 16:00 1/1/2012   |
    | Patching   | Bob   | Windows Updates   | 18:00, 1/1/2012   | 22:00 1/1/2012   |

  And the following substitutions exist:
    | entry_id     | description                | from     | for      |
    | 2            | I have a midterm tonight   | Bob      | Alice    |
    | 1            | Feeling sick today         | Alice    |          |
    | 3            | I have a midterm tonight   | Bob      |          |


  Scenario: Take available substitutions
    Given I am on my substitutions page
    When I select “Lab Hours”
    And I select "Patching"
    And I select "Claim"
    And I go to my finalized calendar page
    Then I should see "Lab Hours"
    And I should see "Patching"