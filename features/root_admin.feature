Feature: Root Administrator Is Created
  As a server manager
  I want to have an account set up on the server
  So that I can initialize the server for further use

  Scenario: Visiting the website redirects me to the init page
    Given I go to the BOS homepage
    And I should see "Initialize Root Admin"
    Then I should see "Berkeley UID"

   Scenario: Inputting my UID allows me to view admin pages
    Given I go to the BOS homepage
    And I fill in "Berkeley UID" with "12345"
    And I go to the "Users" page
    Then I should see "Users"

   Scenario: Inputting my UID allows me to create admins
    Given I go to the BOS homepage
    And I fill in "Berkeley UID" with "12345"
    And I go to the "Users" page
    And I follow "New User"
    And I fill in "User type" with "0"
    And I fill in "Name" with "Test Admin"
    And I fill in "Initials" with "TA"
    And I fill in "Calid" with "54321
    And I press "Save"
    And I go to the "Users" page
    Then I should see "Test Admin"
