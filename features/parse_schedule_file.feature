Feature: Set Availability Calendar
  As an administrator
  I want to upload students' work schedule file
  So that I can assign shifts to them

Background: A Calendar has been created
  Given the following users exist:
    | name         | user_type      | initials |
    | Alice        | 1              | AA       |
    | SYF          | 1              | SYF      |
    | MT           | 1              | MT       |
    | PC           | 1              | PC       |
    | RC           | 1              | RC       |
    | JQ           | 1              | JQ       |
    | CW           | 1              | CW       |
    | RX           | 1              | RX       |
    | NC           | 1              | NC       |
    | Chris        | -1             | CC       |

  And the following periods exist:
    | name             |
    | Finals Week 1    |

  And the following calendars exist:
    | name             | calendar_type  | user_id | period_id|
    | Alice's Calendar | 1              | 1       |  2       |


  And the following labs exist:
    |name   | initials | max_employees | min_employees |
    |Moffit | MMF      | 4             | 1             |
    

  Scenario: parse a flat file to assign shifts for every employee
    When I am logged in as "Chris"
    And I am on the "Admin Labs" page
    And I follow "Submit a Flatfile"
    And I should be on Moffit's upload file page
    When I attach the file "features/file_sample/sample_shifts.txt" to "file_text_file"
    And I press "Upload"
    And I should be on the "Admin Labs" page
    Then I should see "Shifts were successfully assigned."
    And I go to Alice's Shifts page
    And Alice should have 1 entry which starts at "2012-5-7 8:00" and ends at "2012-5-7 9:00"
  
  Scenario: parse a flat file with wrong lab
    When I am logged in as "Chris"
    And I am on the "Admin Labs" page
    And I follow "Submit a Flatfile"
    And I should be on Moffit's upload file page
    When I attach the file "features/file_sample/bad_sample_shifts1.txt" to "file_text_file"
    And I press "Upload"
    Then I should see "This flat file is not for this lab!"
  
   Scenario: parse a flat file with non-exist employee
    When I am logged in as "Chris"
    And I am on the "Admin Labs" page
    And I follow "Submit a Flatfile"
    And I should be on Moffit's upload file page
    When I attach the file "features/file_sample/bad_sample_shifts2.txt" to "file_text_file"
    And I press "Upload"
    Then I should see "Employee with initials: SYK does not exist!"

   Scenario: parse a flat file with expired period
    When I am logged in as "Chris"
    And I am on the "Admin Labs" page
    And I follow "Submit a Flatfile"
    And I should be on Moffit's upload file page
    When I attach the file "features/file_sample/bad_sample_shifts3.txt" to "file_text_file"
    And I press "Upload"
    Then I should see "Commiting shifts for past time!"

   Scenario: parse the same flat file twice
    When I am logged in as "Chris"
    And I am on the "Admin Labs" page
    And I follow "Submit a Flatfile"
    And I should be on Moffit's upload file page
    When I attach the file "features/file_sample/sample_shifts.txt" to "file_text_file"
    And I press "Upload"
    And I should be on the "Admin Labs" page
    Then I should see "Shifts were successfully assigned."
    And I follow "Submit a Flatfile"
    When I attach the file "features/file_sample/sample_shifts.txt" to "file_text_file"
    And I press "Upload"
    And I should see "Selected week calendar not empty!"