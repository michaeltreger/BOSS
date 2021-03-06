Feature: Take Substitutions
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

  And the following periods exist:
    | name             |
    | Finals Week 1    |

  And I am logged in as "Alice"

  And the following labs exist:
    | name     |  initials  |  max_employees  | min_employees |
    | Wheeler  |    WH      |   10            |    1          |
    | Moffit   |    MO      |   25            |    0          |

  And the calendar "Alice's Shifts" has the following entries:
    | description         |  lab       | start_time        | end_time         |
    | Work at Wheeler     |  Wheeler   | 12:00, 1/1/2012   | 14:00 1/1/2012   |
    | Software Training   |  Wheeler   | 14:00, 1/1/2012   | 16:00 1/1/2012   |


  And the calendar "Bob's Shifts" has the following entries:
    | description              |  lab       | start_time        | end_time         |
    | Work at Moffit           |  Moffit    | 17:00, 1/1/2012   | 18:00 1/1/2012   |
    | Presentation             |  Moffit    | 8:00, 1/1/2012    | 11:00 1/1/2012   |
    | I conflict with Alice 1  |  Wheeler   | 11:00, 1/1/2012   | 13:00 1/1/2012   |
    | I conflict with Alice 2  |  Wheeler   | 12:30, 1/1/2012   | 13:00 1/1/2012   |
    | I conflict with Alice 3  |  Wheeler   | 12:30, 1/1/2012   | 15:00 1/1/2012   |
    | I conflict with Alice 4  |  Wheeler   | 11:00, 1/1/2012   | 15:00 1/1/2012   |
    | BacktoBackSameLocation   |  Wheeler   | 11:00, 1/1/2012   | 12:00 1/1/2012   |
    | BacktoBackDiffLocation   |  Moffit    | 11:00, 1/1/2012   | 12:00 1/1/2012   |


  And the following substitutions exist:
    | entry_description          | description             | from_user_id    | to_user_id |
    |   Work at Moffit           | Work at Moffit          |    2            |    1       |
    |   Presentation             | Presentation            |    2            |   nil      |
    |   I conflict with Alice 1  | I conflict with Alice 1 |    2            |   nil      |
    |   I conflict with Alice 2  | I conflict with Alice 2 |    2            |   nil      |
    |   I conflict with Alice 3  | I conflict with Alice 3 |    2            |   nil      |
    |   I conflict with Alice 4  | I conflict with Alice 4 |    2            |   nil      |
    |   BacktoBackSameLocation   | BacktoBackSameLocation  |    2            |   nil      |
    |   BacktoBackDiffLocation   | BacktoBackDiffLocation  |    2            |   nil      |

  Given I am on the "View Substitutions" page
  Scenario: Take available substitutions
    When I check the substitution "Work at Moffit"
    And I check the substitution "Presentation"
    And I press "Take Selected Substitutions"
    And I am on Alice's Shifts page
    And I view the calendar
    Then I should see "Work at Moffit"
    And I should see "Presentation"

  Scenario: Taken substitutions are no longer available
    When I check the substitution "Presentation"
    And I press "Take Selected Substitutions"
    And I am on the "View Substitutions" page
    Then I should not see "Presentation"
    And I should see "Work at Moffit"

  Scenario: Error when I take a sub that conflicts with entries on my calendar
    When I check the substitution "I conflict with Alice 1"
    And I check the substitution "I conflict with Alice 2"
    And I check the substitution "I conflict with Alice 3"
    And I check the substitution "I conflict with Alice 4"
    And I press "Take Selected Substitutions"
    Then I should see "The following subs could not be taken"
    And I should see "I conflict with Alice 1"
    And I should see "I conflict with Alice 2"
    And I should see "I conflict with Alice 3"
    And I should see "I conflict with Alice 4"

  Scenario: When I cannot take a sub, the sub stays available
    When I check the substitution "I conflict with Alice 1"
    And I press "Take Selected Substitutions"
    And I am on the "View Substitutions" page
    Then I should see "I conflict with Alice 1"
  
  Scenario: When I cannot take a sub, the sub does not go on my calendar
    When I check the substitution "I conflict with Alice 1"
    And I press "Take Selected Substitutions"
    And I am on Alice's Shifts page
    And I view the calendar
    Then I should not see "I conflict with Alice 1"

  Scenario: I can take a sub back to back if it is in the same location
    When I check the substitution "BacktoBackSameLocation"
    And I press "Take Selected Substitutions"
    And I am on Alice's Shifts page
    And I view the calendar
    Then I should see "BacktoBackSameLocation"
 
 Scenario: I can not take a sub back to back if it is in a different location
    When I check the substitution "BacktoBackDiffLocation"
    And I press "Take Selected Substitutions"
    Then I should see "The following subs could not be taken"
    And I should see "BacktoBackDiffLocation"
