Feature: Group Labs
  As an administrator
  I want to be able to group labs into units
  So that I can organize and categorize labs more effeciently

Background: A work entry has been added to my calendar

  Given the following users exist:
    | name         | user_type      | initials  |
    | David        | Admin          |   DD      |

  And the following labs exist:
    | name         | initials    | max_employees | min_employees |
    | lab 1        | l1          |  100          | 10            |
    | lab 2        | l2          |  10           | 1             |
    | lab 3        | l3          |  10           | 1             |

  And the following groups exist:
    | name         | unit        |
    | East Labs    | true        |
    | West Labs    | true        |
    | North Labs   | true        |

  And the lab "lab 1" is in the unit "East Labs"
  And the lab "lab 2" is in the unit "West Labs"

  And I am logged in as "David"

  And I am on the "View Labs" page


  Scenario: Add a lab to a unit
    When I follow "details" for "lab 3"
    And I follow "Add to Unit"
    And I select "North Labs" from "lab_groups"
    And I press "Save"
    Then I should see "North Labs"

  Scenario: Labs are sorted alphabetically by unit
    When I am on the "View Labs" page
    And I should see "lab 1"
    And I should see "lab 2"
    And I should see "East Labs"
    And I should see "West Labs"
    Then I should see "East Labs" before "West Labs"
    
