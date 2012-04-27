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

  And the following calendars exist:
    | name             | calendar_type  | user_id |
    | Alice's Calendar | 1              | 1       |

  And the calendar "Alice's Calendar" has the following entries:
    | description         | start_time        | end_time         | type       |
    | Work at Wheeler     | 12:00, 1/1/2012   | 14:00 1/1/2012   | prefer     |
    | Software Training   | 14:00, 1/1/2012   | 16:00 1/1/2012   | rather_not |

  Scenario: parse a flat file to generate employee calendars  
    Given I am logged in as "Chris"
    And I am on parse flat file page
    When I choose a flat file
    And I press "upload"
    Then I should see "upload successfully"
    Then I go to Alice's Calendar page
    I should see Alice's new working calendar