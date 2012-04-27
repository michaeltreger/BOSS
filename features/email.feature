Feature: Email Substitute Shifts
  As a student
  I want to be able to post substitutions for my shifts
  so that any student can view and claim the shifts I can’t make.

Background: A work entry has been added to my calendar

  Given the following users exist:
    | name         | user_type      | initials  | cas_user |
    | Alice        | 1              |   AA      | 1        |
    | Bob          | 1              |   BB      | 2        |
    | Carl         | 1              |   CC      | 3        |
    | David        | 0              |   DD      | 4        |
    
  And I am logged in as "Alice"

  And the following calendars exist:
    | name             | calendar_type  | user_id |
    | Alice's Calendar |   1            |   1     |
    | Bob's Calendar   |   1            |   2     |

  And the following labs exist:
    | name     |  initials  |  max_employees  | min_employees |
    | Wheeler  |    WH      |   10            |    1          |
    | Moffit   |    MO      |   25            |    0          |

  And the calendar "Alice's Calendar" has the following entries:
    | description         |  lab       | start_time        | end_time         |
    | Work at Wheeler     |  Wheeler   | 12:00, 1/1/2012   | 14:00 1/1/2012   |
    | Software Training   |  Wheeler   | 14:00, 1/1/2012   | 16:00 1/1/2012   |


  And the calendar "Bob's Calendar" has the following entries:
    | description              |  lab       | start_time        | end_time         |
    | Work at Moffit           |  Moffit    | 15:00, 1/1/2012   | 18:00 1/1/2012   |
    | Presentation             |  Moffit    | 8:00, 1/1/2012    | 12:00 1/1/2012   |
    | I conflict with Alice 1  |  Wheeler   | 11:00, 1/1/2012   | 13:00 1/1/2012   |
    | I conflict with Alice 2  |  Wheeler   | 12:30, 1/1/2012   | 13:00 1/1/2012   |
    | I conflict with Alice 3  |  Wheeler   | 12:30, 1/1/2012   | 15:00 1/1/2012   |
    | I conflict with Alice 4  |  Wheeler   | 11:00, 1/1/2012   | 15:00 1/1/2012   |
    | BacktoBackSameLocation   |  Wheeler   | 11:00, 1/1/2012   | 12:00 1/1/2012   |
    | BacktoBackDiffLocation   |  Moffit    | 11:00, 1/1/2012   | 12:00 1/1/2012   |


  And the following substitutions exist:
    | entry_id   | description             | from_user_id    | to_user_id |
    |   3        | Work at Moffit          |    2            |    1       |
    |   4        | Presentation            |    2            |   nil      |
    |   5        | I conflict with Alice 1 |    2            |   nil      |
    |   6        | I conflict with Alice 2 |    2            |   nil      |
    |   7        | I conflict with Alice 3 |    2            |   nil      |
    |   8        | I conflict with Alice 4 |    2            |   nil      |
    |   9        | BacktoBackSameLocation  |    2            |   nil      |
    |   10       | BacktoBackDiffLocation  |    2            |   nil      |

  Scenario: Put my shift up for substitution
    Given I am on the "Post a Substitution" page
    When I select the entry with id 1 for substitution
    And I fill in "Description" with "Urgent - fix printer"
    And I press "Make Substitution"
    Then I should recieve an email
    
  Scenario: Take a substitution shift
    Given I am on the "View Substitutions" page
    When I check the substitution "Work at Moffit"
    And I check the substitution "Presentation"
    And I put the substitution in "Alice's Calendar"
    And I press "Take Selected Substitutions"
    Then I should recieve an email
    
