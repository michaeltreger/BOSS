Feature: Post a partial substitution
  As a student
  I want to be able to post substitutions for only parts of my shifts
  so that I can break my shift into pieces if I am not free

Background: A work entry has been added to my calendar
  Given the following users exist:
    | name         | user_type      | initials  |
    | Alice        | 1              |   AA      |
    | Bob          | 1              |   BB      |
    | Carl         | 1              |   CC      |
    | David        | 0              |   DD      |

  And I am logged in as "Alice"

  And the following calendars exist:
    | name             | calendar_type  | user_id |
    | Alice's Calendar |   1            |   1     |

  And the calendar "Alice's Calendar" has the following entries:
    | description         | start_time                             | end_time                              |
    | Work at Wheeler     | Wed, 18 Apr 2012 9:00:00 PDT -07:00    | Wed, 18 Apr 2012 12:00:00 PDT -07:00  |
    | Software Training   | Thu, 19 Apr 2012 10:00:00 PDT -07:00   | Thu, 19 Apr 2012 11:00:00 PDT -07:00  |

  And the following substitutions exist:
    | entry_id   | description                | from_user_id    | to_user_id |
    |   2        | Software Training          |    1            |    2       |

  And I am on the "Post a Substitution" page

  Scenario: Post a substitution for part of my shift
    When I select the entry with id 1 for substitution
    And I choose to substitute a partial shift
    And I select "9:30 AM" from "partial_shift_start"
    And I select "11:30 AM" from "partial_shift_end"
    And I fill in "Description" with "Urgent - fix printer"
    And I press "Make Substitution"
    And I go to the "View Substitutions" page
    Then "My Posted Substitutions" should have 2 entries
    And "My Posted Substitutions" should contain "Urgent - fix printer"
    And "My Posted Substitutions" should contain "Software Training"
    And I should see "09:30AM - 11:30AM"

  Scenario: Cannot set partial shift end time earlier than partial shift begin time
    When I select the entry with id 1 for substitution
    And I choose to substitute a partial shift
    And I select "1:30 PM" from "partial_shift_start"
    And I select "1:00 PM" from "partial_shift_end"
    And I fill in "Description" with "Urgent - fix printer"
    And I press "Make Substitution"
    Then I should see "Invalid partial shift times"

  Scenario: Cannot select partial shift times outside of the selected shift
    When I select the entry with id 1 for substitution
    And I choose to substitute a partial shift
    And I select "11:00 AM" from "partial_shift_start"
    And I select "4:30 PM" from "partial_shift_end"
    And I fill in "Description" with "Urgent - fix printer"
    And I press "Make Substitution"
    Then I should see "Invalid partial shift times"
