Feature: Set Availability Calendar
  As an administrator
  I want to upload students' work schedule file
  So that I can assign shifts to them

Background: A Calendar has been created
  Given the following users exist:
    | name         | user_type      | initials |
    | Alice        | 1              | AA       |
    | Chris        | -1             | CC       |

  And the following periods exist:
    | name             |
    | Finals Week 1    |

  And the following labs exist:
    |name   | initials | max_employees | min_employees |
    |Moffit | MMF      | 4             | 1             |
    

  Scenario: parse a flat file to assign shifts for every employee
    When I am logged in as "Chris"
    And I am on the "Admin Labs" page
    And I follow "Submit a Flatfile"
    And I should be on Moffit's upload file page
    When I attach the file "public/assets/MMF05.07-05.13.txt" to "file_text_file"
    And I press "Upload"
    And I should be on the "Admin Labs" page
    Then I should see "Shifts were successfully assigned."
    And I go to Alice's Shifts page
    And I should see Alice's new working calendar
