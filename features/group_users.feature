Feature: Group Users
  As a supervisor
  I want to be able to add users to groups
  So that I can more easily manage permissions the pertain to a subset of users.

Background: A work entry has been added to my calendar
  Given the following users exist:
    | name         | user_type      |
    | Alice        | 1              |
    | Bob          | 1              |
    | John         | -1             |

  And the following periods exist:
    | name             |
    | Finals Week 1    |
    
  And I am logged in as "John"

  And the following groups exist:
    | name                | group_type     |
    | Full-time employees | 1              |
    | Part-time employees | 1              |

  Scenario: Add a user to a group
    When I go to the "Users" page
    And I select "Alice" from the users page
    And I follow "Add to group"
    And I select "Full-time employees" from the menu
    And I press "Save"
    Then I should see "Full-time employees"

  Scenario: Remove a user from a group
    When I go to the "Users" page
    And I select "Bob" from the users page
    And I follow "Add to group"
    And I select "Part-time employees" from the menu
    And I press "Save"
    And I press remove on "Part-time employees"
    Then I should not see "Part-time employees"

  Scenario: Create a new group
    When I go to the "Groups" page
    And I follow "New Group"
    And I fill in "Name" with "Managers"
    And I fill in "Group type" with "1"
    And I press "Save"
    Then I should see "Managers"

  Scenario: Delete a group
    When I go to the "Groups" page
    And I press destroy on "Part-time employees"
    Then I should not see "Part-time employees"

  Scenario: Deleting a group with users
    When I go to the "Users" page
    And I select "Alice" from the users page
    And I follow "Add to group"
    And I select "Full-time employees" from the menu
    And I press "Save"
    And I go to the "Groups" page
    And I press destroy on "Full-time employees"
    And I go to the "Users" page
    And I select "Alice" from the users page
    Then I should not see "Full-time employees"

  Scenario: View all groups when admin
    When I go to the "Groups" page
    Then I should see "Full-time employees"
    And I should see "Part-time employees"

  Scenario: Only view my groups when nonadmin
   When I am logged in as "Bob"
   And I go to the "Groups" page
   Then I should not see "Full-time employees"
   And I should not see "Part-time employees"

