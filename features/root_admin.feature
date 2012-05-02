Feature: Root Administrator Is Created
  As a server manager
  I want to have an account set up on the server
  So that I can initialize the server for further use

  Scenario: Visiting the website redirects me to the init page
    Given I go to the BOS homepage
    And I should see "Initialize Website"
    Then I should see "Berkeley uid"

   Scenario: Inputting my UID allows me to view admin pages
    Given I go to the BOS homepage
    And I fill in "user_cas_user" with "12345"
    And I fill in "Email" with "joe@mail.com"
    And I press "Save"
    #And I log in as "Root Admin"
    And I go to the "Users" page
    Then I should see "Users"

   Scenario: Inputting my UID allows me to create admins
    Given I go to the BOS homepage
    And I fill in "user_cas_user" with "12345"
    And I fill in "Email" with "joe@mail.com"
    And I press "Save"
    #And I log in as "Root Admin"
    And I go to the "Users" page
    And I follow "New User"
    #And I select "Admin" from "User type"
    And I fill in "Name" with "Test Admin"
    And I fill in "Initials" with "TA"
    And I fill in "user_cas_user" with "54321"
    And I press "Save"
    And I go to the "Users" page
    Then I should see "Test Admin"
