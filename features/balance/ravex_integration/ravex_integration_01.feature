Feature: Balance - RaveX integration tests

  # Assumptions:
  #
  # - Bal_RaveX_Integration_01 exists with pushed draft (rand_uncoupled_setup_01.feature will set this up)

  # Integration Tests
  # - Subject Creation
  # - Randomization
  # - Dispensation
  # - Redispensation
  # - Exclude from Randomization
  # - Deactivate/Reactivate subject

  Background:
    Given I login to "iMedidata" as user "balancemistuser"
    When I search for study "Bal_RaveX_Integration_01"
    And I take a screenshot
    And I select app "RaveX EDC" from search results

  @Balance
  @Release2015.3.0
  @PB148749-002
  Scenario: Create subject in RaveX triggering balance subject create api
    Given I have the following data set:
      | Key             | Value   |
      | random_subject  | Sub<r6> |
    When I add a subject in RaveX with the following data:
      | Field Name  | Type | Value          |
      | Subject ID: | text | random_subject |
    And I take a screenshot
    And I navigate to form "Visit Date" within folders:
      | Folder    |
      | Screening |
    And I enter the following data for the "Visit Date" form:
      | Field Name   | Type | Value      |
      | Visit Date:  | date | 01-01-2015 |
    And I save RaveX EDC form
    And I take a screenshot
    Then I navigate to form "Demographics"
    And I enter the following data for the "Demographics" form:
      | Field Name                | Type       | Value      |
      | Date of Informed Consent  | date       | 01-01-2015 |
      | Date of Birth             | date       | 01-01-1976 |
      | Gender                    | drop_down  | Male       |
      | Race                      | drop_down  | White      |
      | SMOKER                    | drop_down  | Yes        |
    And I save RaveX EDC form
    And I take a screenshot
    Then I navigate to form "Subject Register"
    And I enter the following data for the "Subject Register" form:
      | Field Name                             | Type       | Value  |
      | Is the subject ready to be registered? | check_box  | true   |
    And I save RaveX EDC form
    And I take a screenshot
    And I verify the following Audit Data for field "Subject Created":
      | Audit                                                         |
      | Comment added 'Subject was successfully created in Balance.'. |

    # check balance for subject
    Then I go to home page
    When I search for study "Bal_RaveX_Integration_01"
    And I select app "BalanceValidation" from search results
    Then In Balance I search for subject "random_subject"
    And In Balance I verify the "subjects" table has contents of:
      | Subject ID    | Status | Site            |
      | random_subject   | Active | Balance Site 01 |
    Then In Balance I follow the iMedidata Logo
    And I logout from "iMedidata"

  @Balance
  @Release2015.3.0
  @PB148749-003
  Scenario: Randomize subject in RaveX triggering balance subject randomize api
    When In RaveX I navigate to the Subject List Page
    And In RaveX I select subject "random_subject"
    And I navigate to form "Randomisation Details" within folders:
      | Folder    |
      | Visit 1   |
    And I enter the following data for the "Randomisation Details" form:
      | Field Name                             | Type         | Value  |
      | Is the subject ready to be randomized? | radio_button | Yes    |
    And I save RaveX EDC form
    And I take a screenshot
    And I verify the following Audit Data for field "Subject Randomized":
      | Audit                                             |
      | Comment added 'Subject successfully randomized.'. |
    Then I go to home page
    And I logout from "iMedidata"

  @Balance
  @Release2015.3.0
  @PB148749-004
  Scenario: Dispense to subject in RaveX triggering balance dispense api
    Then In RaveX I navigate to the Subject List Page
    And In RaveX I select subject "random_subject"
    And I navigate to form "Drug Dispensation" within folders:
      | Folder    |
      | Visit 1   |
    And I enter the following data for the "Drug Dispensation" form:
      | Field Name                                   | Type         | Value  |
      | WEIGHT                                       | drop_down    | Heavy  |
      | Click here to receive kit number to dispense | check_box    | true   |
    And I save RaveX EDC form
    And I take a screenshot
    And I verify the following Audit Data for field "Click here to receive kit number to dispense":
      | Audit                                             |
      | Comment added 'Subject dispensation successful.'. |
    Then I go to home page
    And I logout from "iMedidata"


  @Balance
  @Release2015.3.0
  @PB148749-005
  Scenario: Redispense to subject in RaveX triggering balance dispense api
    Then In RaveX I navigate to the Subject List Page
    And In RaveX I select subject "random_subject"
    And In RaveX I add event "Unscheduled Visit" on the subject page
    And I take a screenshot
    And I navigate to form "Unscheduled Dispensation" within folders:
      | Folder                |
      | Unscheduled Visit (1) |
    And I enter the following data for the "Unscheduled Dispensation" form:
      | Field Name                                   | Type         | Value  |
      | WEIGHT                                       | drop_down    | Heavy  |
      | Click here to receive kit number to dispense | check_box    | true   |
    And I save RaveX EDC form
    And I take a screenshot
    And I verify the following Audit Data for field "Click here to receive kit number to dispense":
      | Audit                                             |
      | Comment added 'Subject dispensation successful.'. |
    Then I go to home page
    And I logout from "iMedidata"

  @Balance
  @Release2015.3.0
  @PB148749-006
  Scenario: Exclude subject from randomization in RaveX
    Then In RaveX I navigate to the Subject List Page
    And In RaveX I select subject "random_subject"
    And I take a screenshot
    And I navigate to form "Exclude from Randomization" within folders:
      | Folder  |
      | Visit 1 |
    And I enter the following data for the "Exclude from Randomization" form:
      | Field Name                  | Type         | Value |
      | Exclude from Randomization  | check_box    | true  |
      | Reason for Exclusion        | text         | test  |
    And I save RaveX EDC form
    And I take a screenshot
    And I verify the following Audit Data for field "Exclude from Randomization":
      | Audit                                                                 |
      | Comment added 'Subject was successfully removed from randomization.'. |
    Then I go to home page
    And I logout from "iMedidata"

  @Balance
  @Release2015.3.0
  @PB148749-007
  Scenario: Deactivate/Reactivate subject in RaveX
    Then In RaveX I navigate to the Subject List Page
    And In RaveX I select subject "random_subject"
    And I take a screenshot
    And I navigate to form "Supply Deactivation" within folders:
      | Folder  |
      | Visit 1 |
    And I enter the following data for the "Supply Deactivation" form:
      | Field Name           | Type         | Value |
      | Subject Deactivated  | check_box    | true  |
      | Reason               | text         | test  |
    And I save RaveX EDC form
    And I take a screenshot
    And I verify the following Audit Data for field "Subject Deactivated":
      | Audit                                        |
      | Comment added 'Subject status was updated.'. |

    # check deactivated in balance
    Then I go to home page
    When I search for study "Bal_RaveX_Integration_01"
    And I select app "BalanceValidation" from search results
    Then In Balance I search for subject "random_subject"
    And In Balance I verify the "subjects" table has contents of:
      | Subject ID       | Status      |
      | random_subject   | Deactivated |
    Then In Balance I follow the iMedidata Logo
    And I logout from "iMedidata"

