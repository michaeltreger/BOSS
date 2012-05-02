Feature: Time-off Request
  As an admin
  I want to view all students' time-off requests
  So that I know who will not work for that time interval

Background: Users created
  Given the following users exist:
    | name         | user_type      |
    | Alice        | 1              |
    | Bob          | 1              |
    | Hell         | -1             |
    | Chris        | 0              |

  And the following periods exist:
    | name             |
    | Finals Week 1    |


  And the following calendars exist:
    | name             | calendar_type  | user_id | period_id|
    | Alice's Calendar | 1              | 1       |  1       |

  And the calendar "Alice's Calendar" has the following entries:
    | description         | start_time        | end_time         | entry_type |
    | Soccer Practice     | 12:00, 1/1/2012   | 14:00 1/1/2012   | obligation |
    |                     | 14:00, 1/1/2012   | 16:00 1/1/2012   | rather_not |
  
  And the following time-off requests for Alice exist:
    | user_id | start_time                 | end_time                   | submission                  | day_notice    | description |
    |  3      | 2012-4-29 12:00 PDT -07:00 | 2012-4-29 13:00 PDT -07:00 | 2012-4-20 12:00 PDT -07:00  | passed 4 days | go shopping |
    |  2      | 2012-4-30 9:00 PDT -07:00  | 2012-4-30 10:00 PDT -07:00 | 2012-4-21 19:00 PDT -07:00  | 2 days left   | go swimming |

 Scenario: Admin view all time-off requests
   Given I am logged in as "Hell"
   And I am on all time-off requests page
   And I should see a request starts at "2012-4-29 12:00" and ends at "2012-4-29 13:00" with name "Hell"
   And I should see a request starts at "2012-4-30 9:00" and ends at "2012-4-30 10:00" with name "Bob"
   And I should not see "some other requests"

Scenario: Admin view a request's description
   Given I am logged in as "Hell"
   And I am on all time-off requests page
   When I follow "Details"
   Then I should see a description "go shopping"
   When I follow "Back"
   Then I should see a request starts at "2012-4-29 12:00" and ends at "2012-4-29 13:00" with name "Hell"
   Then I should see a request starts at "2012-4-30 9:00" and ends at "2012-4-30 10:00" with name "Bob"
   And I am on all time-off requests page
  

 Scenario: Scheduler make a time-off request
    Given I am logged in as "Chris"
    And I am on my time-off requests page
    When I follow "New Request"
    Then I should be on the Create New Request page
    When I select "2013" from "time_off_request_start_time_1i"
    And I select "May" from "time_off_request_start_time_2i"
    And I select "29" from "time_off_request_start_time_3i"
    And I select "15" from "time_off_request_start_time_4i"
    And I select "30" from "time_off_request_start_time_5i"
    And I select "2013" from "time_off_request_end_time_1i"
    And I select "May" from "time_off_request_end_time_2i"
    And I select "29" from "time_off_request_end_time_3i"
    And I select "16" from "time_off_request_end_time_4i"
    And I select "0" from "time_off_request_end_time_5i"
    And I fill in "time_off_request_description" with "go eating"
    And I press "Save Changes"
    Then I should be on my time-off requests page
    And I should see a request starts at "2013-5-29 15:30" and ends at "2013-5-29 16:00"

  Scenario: Scheduler view all time-off requests
     Given I am logged in as "Chris"
     And I am on all time-off requests page
     And I should see a request starts at "2012-4-29 12:00" and ends at "2012-4-29 13:00" with name "Hell"
     And I should see a request starts at "2012-4-30 9:00" and ends at "2012-4-30 10:00" with name "Bob"
     And I should not see "some other requests"
