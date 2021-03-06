Feature: Substitute Shifts For Anyone
  As a student
  I want to be able to post substitutions for my shifts
  so that any student can view and claim the shifts I can’t make.

Background: A work entry has been added to my calendar

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

  And the calendar "Alice's Shifts" has the following entries:
    | description         | start_time        | end_time         |
    | Work at Wheeler     | 12:00, 1/1/2013   | 14:00 1/1/2013   |
    | Software Training   | 14:00, 1/1/2012   | 16:00 1/1/2012   |

  And the following substitutions exist:
    | entry_description    | description                | from_user_id    | to_user_id |
    |   Software Training  | Software Training          |    1            |    2       |

  And I am on the "Post a Substitution" page

  Scenario: Put my shift up for substitution for anybody
    When I select the entry with description "Work at Wheeler" for substitution
    And I fill in "Description" with "Urgent - fix printer"
    And I press "Make Substitution"
    And I go to the "View Substitutions" page
    Then "My Posted Substitutions" should have 2 entries
    And "My Posted Substitutions" should contain "Urgent - fix printer"
    And "My Posted Substitutions" should contain "Software Training"
  
  Scenario: Posted subs are still on my calendar
    When I select the entry with description "Work at Wheeler" for substitution
    And I fill in "Description" with "Wheeler Work"
    And I press "Make Substitution"
    And I am on Alice's Shifts page
    And I view the calendar
    Then I should see "Work at Wheeler"

  Scenario: Substitution cannot be posted twice for one entry
    Then I should not see the entry with description "Software Training" for substitution

  Scenario: Substitution cannot be posted with no entry
    When I select the entry with description "Work at Wheeler" for substitution
    And I fill in "Description" with "Urgent - fix printer"
    And I press "Make Substitution"
    And I am on the "Post a Substitution" page
    Then I should see "You have no shifts to substitute"
    And I should not see "Select a Shift to Substitute"

  Scenario: Cannot create a sub without picking an entry
    When I press "Make Substitution"
    Then I should see "Please select a shift to substitute."

  Scenario: Delete a substitution
    When I go to the "View Substitutions" page
    And I delete my substitution with description "Software Training"
    Then I should be on the "View Substitutions" page
    And "My Posted Substitutions" should not contain "Software Training"
