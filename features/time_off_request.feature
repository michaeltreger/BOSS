Feature: Time-off Request
  As a student
  I want to make a time-off request
  So that I don't need to work for that time interval

Background: Users created
  Given the following users exist:
    | name         | user_type      |
    | Alice        | 1              |
    | Bob          | 1              |
    | Chris        | 0              |

  And the following calendars exist:
    | name             | calendar_type  | user_id | period_id|
    | Alice's Calendar | 1              | 1       |  2       |

  And the calendar "Alice's Calendar" has the following entries:
    | description         | start_time        | end_time         | entry_type |
    | Soccer Practice     | 12:00, 1/1/2012   | 14:00 1/1/2012   | obligation |
    |                     | 14:00, 1/1/2012   | 16:00 1/1/2012   | rather_not |
  
  And the following time-off requests for Alice exist:
    | user_id | start_time                 | end_time                   | submission                  | day_notice    | description |
    |  1      | 2012-4-29 12:00 PDT -07:00 | 2012-4-29 13:00 PDT -07:00 | 2012-4-21 12:00 PDT -07:00  | passed 4 days | go shopping |
    |  2      | 2012-4-30 9:00 PDT -07:00  | 2012-4-30 10:00 PDT -07:00 | 2012-4-21 19:00 PDT -07:00  | 2 days left   | go swimming |

  Scenario: Employee make a time-off request
    Given I am logged in as "Alice"
    And I am on my time-off requests page
    And I should see a request starts at "2012-4-29 12:00" and ends at "2012-4-29 13:00"
    When I follow "New Request"
    Then I should be on the Create New Request page
    When I select "2013" from "time_off_request_start_time_1i"
    And I select "Apr" from "time_off_request_start_time_2i"
    And I select "29" from "time_off_request_start_time_3i"
    And I select "15" from "time_off_request_start_time_4i"
    And I select "30" from "time_off_request_start_time_5i"
    And I select "2013" from "time_off_request_end_time_1i"
    And I select "Apr" from "time_off_request_end_time_2i"
    And I select "29" from "time_off_request_end_time_3i"
    And I select "16" from "time_off_request_end_time_4i"
    And I select "0" from "time_off_request_end_time_5i"
    And I fill in "time_off_request_description" with "go gank"
    And I press "Save Changes"
    Then I should be on my time-off requests page
    And I should see a request starts at "2013-4-29 15:30" and ends at "2013-4-29 16:00"

  Scenario: Employee make a invalid time-off request
    Given I am logged in as "Alice"
    And I am on my time-off requests page
    When I follow "New Request"
    Then I should be on the Create New Request page
    When I select "2013" from "time_off_request_start_time_1i"
    And I select "Apr" from "time_off_request_start_time_2i"
    And I select "29" from "time_off_request_start_time_3i"
    And I select "15" from "time_off_request_start_time_4i"
    And I select "30" from "time_off_request_start_time_5i"
    And I select "2013" from "time_off_request_end_time_1i"
    And I select "Jan" from "time_off_request_end_time_2i"
    And I select "29" from "time_off_request_end_time_3i"
    And I select "16" from "time_off_request_end_time_4i"
    And I select "0" from "time_off_request_end_time_5i"
    And I fill in "time_off_request_description" with "go gank"
    And I press "Save Changes"
    Then I should see "Invalid Time"

  Scenario: Delete a time-off request
    Given I am logged in as "Alice"
    And I am on my time-off requests page
    When I follow "Delete" on a request starts at "2012-4-29 12:00" and ends at "2012-4-29 13:00"
    Then I should be on my time-off requests page
    And I should not see a request starts at "2012-4-29 12:00" and ends at "2012-4-29 13:00"
  
  Scenario: Edit description of a time-off request
    Given I am logged in as "Alice"
    And I am on my time-off requests page
    When I follow "Details" on a request starts at "2012-4-29 12:00" and ends at "2012-4-29 13:00" 
    Then I should see "go shopping"
    When I follow "Edit" on description page
    And I fill in "time_off_request_description" with "go sleeping"
    And I press "Save Changes"
    Then I should be on my time-off requests page
    And I should see "Time off request was successfully updated." on my requests page

  Scenario: Can not view other employees' requests
    Given I am logged in as "Bob"
    And I am on my time-off requests page
    Then I should see a request starts at "2012-4-30 9:00 PDT -07:00" and ends at "2012-4-30 10:00 PDT -07:00"
    And I should not see a request starts at "2012-4-29 12:00" and ends at "2012-4-29 13:00"