Feature: Post Subs for Anyone
  As an admin
  I want to be able to post subs for others
  So that I can reschedule shifts when students have failed to do so

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

  And I am logged in as "David"

  And the calendar "Alice's Shifts" has the following entries:
    | description         | start_time        | end_time         |
    | Work at Wheeler     | 12:00, 1/1/2013   | 14:00 1/1/2013   |
    | Software Training   | 14:00, 1/1/2012   | 16:00 1/1/2012   |

  And the following substitutions exist:
    | entry_id   | description                | from_user_id    | to_user_id |
    |   2        | Software Training          |    1            |    2       |

  And I am on the "Manage Substitutions" page

  Scenario: Put someone else's shift up for substitution
    When I follow "Alice's Shifts"
    And I select the entry with id 1 for substitution
    And I fill in "Description" with "Urgent - fix printer"
    And I press "Make Substitution"
    And I go to the "View Substitutions" page
    Then "My Posted Substitutions" should have 0 entries
    And "Available Substitutions" should have 1 entries
    And "Available Substitutions" should contain "Urgent - fix printer"
    And "Reserved Substitutions" should have 0 entries
  
  Scenario: Posted subs are still on original owner's calendar
    When I follow "Alice's Shifts"
    When I select the entry with id 1 for substitution
    And I fill in "Description" with "Wheeler Work"
    And I press "Make Substitution"
    And I am on Alice's Shifts page
    And I view the calendar
    Then I should see "Work at Wheeler"

  Scenario: Substitution cannot be posted twice for one entry
    Then I should not see the entry with id 2 for substitution

