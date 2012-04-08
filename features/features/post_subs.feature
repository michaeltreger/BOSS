Feature: Substitute Shifts
  As a student
  I want to be able to post substitutions for my shifts
  So that other students can view and claim the shifts I can’t make.

Background: A work entry has been added to my calendar
  Given the following users exist:
    | name         | user_type   |
    | Alice        |       1     |
    | Bob          |       1     |    

  And I am logged in as 'Alice'

  And 'Alice' has the following calendars:
    | name           | calendar_type     |
    | 'My Calendar'  |       1           |

  And 'My Calendar' has the following entries:
    | name       | owner  | description         | start_time        | end_time         | repeating | finalized |
    | Work       | Alice  | Work at Wheeler     | 12:00, 1/1/2012   | 14:00 1/1/2012   | false  | true |
    | Lab Hours  | Bob    | Software Training   | 14:00, 1/1/2012   | 16:00 1/1/2012   | false  | true |

  And the following substitutions exist:
    | entry_id     | description                | from     | for        |
    | 2            | I have a midterm tonight   | Bob      | Alice      |
  And I am on my finalized calendar page

  Scenario: Put my shift up for substitution for anybody
    When I press substitute
    And I set “Entry” to “Work”
    And I set “Description” to “Feeling sick today”
    And I press submit
    And I go to my substitutions page
    Then I should see “Work”
    And I should see  “Lab Hours”
  Scenario: See a substituted shift targeted for me
    When I press substitute
    And I set “Entry” to “Work”
    And I set “Description” to “I can trade subs with you Bob”
    And I set “user” to “Bob”
    And I press submit
    And I go to my substitutions page
    Then I should not see “Work”
    And I should see “Lab Hours”
  Scenario: See all substitutions
    When I press substitute
    And I set “Entry” to “Work”
    And I set “Description” to “Can you stay an hour later Bob?”
    And I set “user” to “Bob”
    And I press submit
    And I go to the “All Substitutions” page
    Then I should see “Work”
    And I should see “Lab Hours”