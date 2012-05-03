Feature: View Lab Shifts
  As an admin or scheduler
  I want to be able to view all shifts at a lab
  So that I can see all relevant student schedules at the same time

Background: A lab with scheduled shifts exists

  Given the following users exist:
    | name         | user_type      | initials  | activated |
    | Alice        | 1              |   AA      | true      |
    | Bob          | 1              |   BB      | true      |
    | Carl         | 1              |   CC      | true      |
    | David        | 0              |   DD      | true      |

  And the following periods exist:
    | name             |
    | Finals Week 1    |

  And I am logged in as "Alice"

  And the following labs exist:
    | name         | initials         | max_employees  | min_employees   |
    | Lab 1        |  L1              |  15            |  3              |
    | Lab 2        |  L2              |  3             |  3              |

  And the calendar "Alice's Shifts" has the following entries:
    | description         | lab     | start_time        | end_time         |
    | Work at Wheeler     | Lab 1   | 12:00, 1/1/2013   | 14:00 1/1/2013   |
    | Software Training   | Lab 1   | 14:00, 1/1/2012   | 16:00 1/1/2012   |
    | Something Else      | Lab 2   | 12:00, 1/4/2012   | 18:00 1/4/2012   |

  And the calendar "Bob's Shifts" has the following entries:
    | description         | lab     | start_time        | end_time         |
    | Work at Wheeler     | Lab 1   | 10:00, 1/1/2013   | 14:00 1/1/2013   |
    | Software Training   | Lab 2   | 15:00, 1/1/2012   | 16:00 1/1/2012   |
    | Something Else      | Lab 2   | 17:00, 1/4/2012   | 18:00 1/4/2012   |

  And the calendar "Carl's Shifts" has the following entries:
    | description         | lab     | start_time        | end_time         |
    | Work at Wheeler     | Lab 2   | 12:00, 1/1/2013   | 14:00 1/1/2013   |
    | Software Training   | Lab 2   | 14:00, 1/1/2012   | 16:00 1/1/2012   |
    | Something Else      | Lab 2   | 12:00, 1/4/2012   | 18:00 1/4/2012   |


  Scenario: View all shifts at a lab
    When I am on the "Lab 1" Lab Shifts page
    And I view the calendar
    Then I should see "AA"
    And I should see "BB"
    And I should not see "CC"
  
