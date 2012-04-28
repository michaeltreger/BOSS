Feature: Set Availability Calendar
  As an administrator
  I want to upload students' work schedule file
  So that I can assign shifts to them

Background: A Calendar has been created
  Given the following users exist:
    | name         | user_type      |
    | Alice        | 1              |
    | Chris        | 0              |

  And I am logged in as "Alice"

  And the calendar "Alice's Shifts" has the following entries:
    | description         | start_time        | end_time         | type       |
    | Work at Wheeler     | 12:00, 1/1/2012   | 14:00 1/1/2012   | prefer     |
    | Software Training   | 14:00, 1/1/2012   | 16:00 1/1/2012   | rather_not |
    And I am logged in as "Chris"
    And I am on parse flat file page

  Scenario: parse a flat file to generate employee calendars  
    When I choose a flat file
    And I press "upload"
    Then I should see "upload successfully"
    And I go to Alice's Shifts page
    And I should see Alice's new working calendar
