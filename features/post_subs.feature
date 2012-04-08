Feature: Substitute Shifts
  As a student
  I want to be able to post substitutions for my shifts
  So that other students can view and claim the shifts I can’t make.

Background: A work entry has been added to my calendar
  Given the following users exist:
    | name         | user_type      |
    | Alice        | 1              |
    | Bob          | 1              |    
  And I am logged in as “Alice”

  And the following calendars exist:
    | name             | calendar_type  | user_id |
    | Alice's Calendar |   1            |   1     |

  And the calendar "Alice's Calendar" has the following entries:
    | name     | description         | start_time        | end_time         |
    | Work     | Work at Wheeler     | 12:00, 1/1/2012   | 14:00 1/1/2012   |
    | Lab Hours| Software Training   | 14:00, 1/1/2012   | 16:00 1/1/2012   |

  And the following substitutions exist:
    | entry_id     | description                | user_id     |
    | 2            | I have a midterm tonight   | 1           |

  And I am on the "Post a Substitution" page

  Scenario: Put my shift up for substitution for anybody
    When I select the entry with id 1
    And I fill in “Description” with “Feeling sick today”
    And I press submit
    And I go to the "View Substitutions" page
    Then "My Posted Substitutions" should have 2 entries
    Then "My Posted Substitutions" should contain "Work"
    And "My Posted Substitutions" should contain “Lab Hours”

  Scenario: Substitution cannot be posted twice for one entry
    Then I should not see an entry with id 2

  Scenario: Substitution cannot be posted with no entry
    Then I should see "You have no shifts to substitute"
    And I should not see "Select a Shift to Substitute"

  Scenario: Delete a substitution
    When I go to the "View Substitutions" page
    And I press delete next to my first posted substitution
    Then I should be on the "View Substitutions" page
    And I should not see "My Posted Substitutions"
