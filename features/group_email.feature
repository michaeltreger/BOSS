Feature: Group Users
  As a supervisor
  I want to be able to set a mailing list for an entire group
  So that I can more easily contact a subset of users

Background: A work entry has been added to my calendar
  Given the following users exist:
    | name         | user_type      |
    | John         | -1             |

    
  And I am logged in as "John"

  And the following groups exist:
    | name                | group_type     |
    | Full-time employees | 1              |

  And I am on the "Groups" page

  Scenario: Create a group with an email
    When I follow "New Group"
    And I fill in "Name" with "Part-time employees"
    And I fill in "Email" with "ptemp@BOS.edu"
    And I press "Save"
    Then I should see "ptemp@BOS.edu"
   
  Scenario: add an email to an existing group
    When I edit the group "Full-time employees"
    And I fill in "Email" with "ftemp@BOS.edu"
    And I press "Save"
    Then I should see "ftemp@BOS.edu"
    
