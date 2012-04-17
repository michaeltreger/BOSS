Feature: View Students Calendars
  As an administrator
  I want to view the student’s uploaded calendars
  So that I can assign schedules to students

Background: A Calendar has been created
  Given the following users exist:
    | name         | user_type      |
    | Alice        | 1              |

  And the following calendars exist:
    | name             | calendar_type  | user_id |
    | Alice's Calendar | 1              | 1       |
    
  And the following time edits exist:
    | start_time      | duration | comment                | user_id | calendar_id |
    | 8:00, 1/1/2012  | -1       | "Alarm did not go off" | 1       | 1           |


  Scenario: Alice can create a time edit
    Given I am logged in as "Alice"
    And I am on the "New Time Edit" page
    When I fill in Start Time with "14:00, 1/1/2012"
    And I fill in "Duration" with "2"
    And I fill in "Comment" with "Lab training"
    And I select MMF facility
    And I press "Save"
    Then I should be on the "Time Edits" page
    And I should see "Lab training" 
    
    
  Scenario: Alice can edit a time edit
    Given I am logged in as "Alice"
    And I am on the "Time Edit" page
    And I follow "Edit"
    And I fill in "Duration" with "2"
    And I press "Save"
    Then I should be on the "Time Edit" page
    And I should see "2"
