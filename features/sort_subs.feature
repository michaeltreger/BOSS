Feature: Sort Substitutions
  As a student or admin
  I want to be able to sort and filter substitutions
  So that I can find specific subs or search for available subs

Background: A work entry has been added to my calendar

  Given the following users exist:
    | name         | user_type      | initials  |
    | Alice        | 1              |   AA      |
    | Bob          | 1              |   BB      |
    | Carl         | 1              |   CC      |
    | David        | 0              |   DD      |

  And the following labs exist:
    | name         | initials    | max_employees | min_employees |
    | lab 1        | l1          |  100          | 10            |
    | lab 2        | l2          |  10           | 1             |
    
  And I am logged in as "Carl"

  And the calendar "Alice's Shifts" has the following entries:
    | description         | start_time                             |  end_time                             | lab |
    | Meeting 1           | Wed, 18 Apr 2013 10:00:00 PDT -07:00   |  Wed, 18 Apr 2013 12:00:00 PDT -07:00 | lab 1        |
    | Meeting 3           | Wed, 18 Apr 2013 14:00:00 PDT -07:00   |  Wed, 18 Apr 2013 16:00:00 PDT -07:00 | lab 1        |
    | Meeting 5           | Wed, 18 Apr 2013 18:00:00 PDT -07:00   |  Wed, 18 Apr 2013 20:00:00 PDT -07:00 | lab 2        |
    | Meeting 7           | Wed, 18 Apr 2013 22:00:00 PDT -07:00   |  Wed, 18 Apr 2013 24:00:00 PDT -07:00 | lab 2        |


  And the calendar "Bob's Shifts" has the following entries:
    | description         | start_time                             | end_time                              | lab  |
    | Meeting 2           | Wed, 18 Apr 2013 12:00:00 PDT -07:00   |  Wed, 18 Apr 2013 14:00:00 PDT -07:00 | lab 1       |
    | Meeting 4           | Wed, 18 Apr 2013 16:00:00 PDT -07:00   |  Wed, 18 Apr 2013 18:00:00 PDT -07:00 | lab 2       |
    | Meeting 6           | Wed, 18 Apr 2013 20:00:00 PDT -07:00   |  Wed, 18 Apr 2013 22:00:00 PDT -07:00 | lab 2       |

  And the calendar "Carl's Shifts" has the following entries:
    | description         | start_time                             | end_time                              | lab  |
    | Meeting D           | Wed, 18 Apr 2013 12:00:00 PDT -07:00   |  Wed, 18 Apr 2013 18:00:00 PDT -07:00 | lab 1       |



  And the following substitutions exist:
    | entry_description  | description            | from_user_id    | to_user_id    |
    |   Meeting 1        | Sub 1                  |    1            |    nil        |
    |   Meeting 3        | Sub 3                  |    1            |    nil        |
    |   Meeting 5        | Sub 5                  |    1            |    nil        |
    |   Meeting 7        | Sub 7                  |    1            |    nil        |
    |   Meeting 2        | Sub 2                  |    2            |    nil        |
    |   Meeting 4        | Sub 4                  |    2            |    nil        |
    |   Meeting 6        | Sub 6                  |    2            |    nil        |

  And I am on the "View Substitutions" page


  Scenario: Sort by time
    When I follow "Shift Time"
    Then I should see "Sub 1" before "Sub 2"
    And I should see "Sub 2" before "Sub 3"
    And I should see "Sub 3" before "Sub 4"
    And I should see "Sub 4" before "Sub 5"
    And I should see "Sub 5" before "Sub 6"
    And I should see "Sub 6" before "Sub 7"

  Scenario: Sort by location
    When I follow "Location"
    Then I should see "Sub 1" before "Sub 5"
    And I should see "Sub 3" before "Sub 5"
    And I should see "Sub 2" before "Sub 5"

  Scenario: Sort by Posted By
    When I follow "Posted By"
    Then I should see "Sub 1" before "Sub 2"
    And I should see "Sub 3" before "Sub 2"
    And I should see "Sub 5" before "Sub 2"
    And I should see "Sub 7" before "Sub 2"

  Scenario: Show only subs I can take
    When I check "filters[subs_conflict]"
    And I press "Update"
    Then I should see "Sub 1"
    And I should not see "Sub 2"
    And I should not see "Sub 3"
    And I should not see "Sub 4"
    And I should not see "Sub 5"
    And I should see "Sub 6"
    And I should see "Sub 7"

  Scenario: Hide Day Subs (8 - 17)
    When I check "filters[subs_day]"
    And I press "Update"
    Then I should not see "Sub 1"
    And I should not see "Sub 2"
    And I should not see "Sub 3"
    And I should not see "Sub 4"
    And I should see "Sub 5"
    And I should see "Sub 6"
    And I should see "Sub 7"

  Scenario: Hide Evening Subs (17 - 22)
    When I check "filters[subs_evening]"
    And I press "Update"
    Then I should see "Sub 1"
    And I should see "Sub 2"
    And I should see "Sub 3"
    And I should see "Sub 4"
    And I should not see "Sub 5"
    And I should not see "Sub 6"
    And I should see "Sub 7"

  Scenario: Hide Late Night Subs (22 - 8)
    When I check "filters[subs_late_night]"
    And I press "Update"
    Then I should see "Sub 1"
    And I should see "Sub 2"
    And I should see "Sub 3"
    And I should see "Sub 4"
    And I should see "Sub 5"
    And I should see "Sub 6"
    And I should not see "Sub 7"
