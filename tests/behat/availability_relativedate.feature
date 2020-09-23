@eWallah @availability @availability_relativedate @javascript
Feature: availability_relativedate
  In order to control student access to activities
  As a teacher
  I need to set date conditions which prevent student access

  Background:
    Given the following "users" exist:
      | username | timezone |
      | teacher1 | 5        |
      | student1 | 5        |
      | student2 | 5        |
    And the following "course" exists:
      | fullname  | Course 1   |
      | shortname | C1         |
      | category  | 0          |
      # Wednesday, July 15, 2020 12:00:00 PM GMT
      | startdate | 1594814400 |
      # Tuesday, September 15, 2020 12:00:00 PM GMT
      | enddate   | 1600171200 |
    And the following config values are set as admin:
      | enableavailability   | 1 |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | student1 | C1     | student        |
      | student2 | C1     | student        |
    And I log in as "teacher1"
    And I am on "Course 1" course homepage
    And I add "Self enrolment" enrolment method with:
      | id_name                 | Test student enrolment |
      | id_enrolenddate_enabled | 1                      |
    And I am on "Course 1" course homepage with editing mode on

  Scenario: Restrict section0
    When I edit the section "0"
    And I expand all fieldsets
    And I click on "Add restriction..." "button"
    Then "Relative date" "button" should not exist in the "Add restriction..." "dialogue"

  Scenario: Test condition
    When I add a "Page" to section "1"
    And I set the following fields to these values:
      | Name         | Page 1: 2 hours after course start date |
      | Description  | Test |
      | Page content | Test |
    And I expand all fieldsets
    And I click on "Add restriction..." "button"
    And I click on "Relative date" "button" in the "Add restriction..." "dialogue"
    And I set the field "relativenumber" to "2"
    And I set the field "relativednw" to "1"
    And I set the field "relativestart" to "1"
    And I press "Save and return to course"

    And I add a "Page" to section "1"
    And I set the following fields to these values:
      | Name         | Page 2: 4 days before course end date |
      | Description  | Test |
      | Page content | Test |
    And I expand all fieldsets
    And I click on "Add restriction..." "button"
    And I click on "Relative date" "button" in the "Add restriction..." "dialogue"
    And I set the field "relativenumber" to "4"
    And I set the field "relativednw" to "2"
    And I set the field "relativestart" to "2"
    And I click on ".availability-item .availability-eye img" "css_element"
    And I press "Save and return to course"

    And I add a "Page" to section "1"
    And I set the following fields to these values:
      | Name         | Page 3: 5 weeks after user enrolment date |
      | Description  | Test   |
      | Page content | Test   |
    And I expand all fieldsets
    And I click on "Add restriction..." "button"
    And I click on "Relative date" "button" in the "Add restriction..." "dialogue"
    And I set the field "relativenumber" to "5"
    And I set the field "relativednw" to "3"
    And I set the field "relativestart" to "3"
    And I click on ".availability-item .availability-eye img" "css_element"
    And I press "Save and return to course"

    And I add a "Page" to section "1"
    And I set the following fields to these values:
      | Name         | Page 4: 7 months after enrolment method end date|
      | Description  | Test   |
      | Page content | Test   |
    And I expand all fieldsets
    And I click on "Add restriction..." "button"
    And I click on "Relative date" "button" in the "Add restriction..." "dialogue"
    And I set the field "relativenumber" to "7"
    And I set the field "relativednw" to "4"
    And I set the field "relativestart" to "4"
    And I press "Save and return to course"

    # 5 days after course start date.
    And I edit the section "2"
    And I expand all fieldsets
    Then I should see "None" in the "Restrict access" "fieldset"
    When I click on "Add restriction..." "button"
    And  I click on "Relative date" "button" in the "Add restriction..." "dialogue"
    And I set the field "relativenumber" to "5"
    And I set the field "relativednw" to "2"
    And I set the field "relativestart" to "1"
    And I click on ".availability-item .availability-eye img" "css_element"
    And I press "Save changes"

    And I edit the section "2"
    And I expand all fieldsets
    Then I should see "5" in the "Restrict access" "fieldset"
    And I should see "days" in the "Restrict access" "fieldset"
    And I should see "after course start date" in the "Restrict access" "fieldset"
    And I press "Cancel"

    # 5 days before course end date.
    And I edit the section "3"
    And I expand all fieldsets
    Then I should see "None" in the "Restrict access" "fieldset"
    When I click on "Add restriction..." "button"
    And  I click on "Relative date" "button" in the "Add restriction..." "dialogue"
    And I set the field "relativenumber" to "5"
    And I set the field "relativednw" to "2"
    And I set the field "relativestart" to "2"
    And I click on ".availability-item .availability-eye img" "css_element"
    And I press "Save changes"

    Then I should see "Page 1" in the "region-main" "region"
    # 2 hours after course start date.
    And I should see "From 15 July 2020, 5:00 PM" in the "region-main" "region"
    # 4 days before course end date.
    And I should see "Until 15 September 2020, 5:00 PM" in the "region-main" "region"
    # 5 weeks after user enrolment date.
    And I should see "From 25 October 2020" in the "region-main" "region"
    # 7 months after enrolment method end date.
    And I should see "From 20 April 2021" in the "region-main" "region"
    # 5 days after course start date.
    And I should see "From 20 July 2020" in the "region-main" "region"
    # 5 days before course end date.
    And I should see "Until 10 September 2020" in the "region-main" "region"
    And I log out

    # Log back in as student.
    When I am on the "C1" "Course" page logged in as "student1"
    Then I should see "Page 1" in the "region-main" "region"
    And I should see "Page 2" in the "region-main" "region"
    But I should not see "Page 3" in the "region-main" "region"
    And I should see "Page 4" in the "region-main" "region"
    And I should see "Topic 2" in the "region-main" "region"
    And I should see "Topic 3" in the "region-main" "region"
