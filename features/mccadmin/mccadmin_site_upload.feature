Feature: MCC Admin site upload functional test.

  As a user with admin role, I should be a able to upload sites to a MCC study within a client division.

  Pre-testing Assumptions: A mcc-enabled study group.  A user with 'admin' role for the client division.

  @Release2015.2.0
  @Draft
  @PlatformService
  Scenario: As a client division admin user, I am able to create a new study and upload sites.
    Given I create a csv spreadsheet named "mcc_test_sites.csv" with values below:
      | Medical Facility Name         | Medinova Hospital            |
      | Client Division Site Number   | cdsite<c4>                   |
      | Study Environment Site Number | site<c4>                     |
      | PI Email Address              | test_pi_user_<c4>@gmail.com  |
      | PI First Name                 | Neil                         |
      | PI Last Name                  | Armstrong                    |
      | PI Role                       | PI                           |
      | Environment                   | Development                  |
      | Site Name                     | Medinova Hospital            |
      | Street Address                | 1969 Lunar Blvd              |
      | City                          | Cincinnati                   |
      | State                         | Ohio                         |
      | Country                       | United States                |
      | Postal Code                   | 45201                        |
    And I login to "iMedidata" as user "mcc_admin_sqa"
    And I navigate to "MCCAdmin" for study group "MCC Autotest CD01" from iMedidata
    And I navigate to All Studies page and create study using the values below:
      | Protocol ID | Use Protocol ID | Study Name     | Primary Indication       | Secondary Indication | Phase   | Configuration Type  | Test Study |
      | MCC_PID_<l> | False           | MCC_Study_<l>  | Intracerebral Hemorrhage | Acute Pancreatitis   | Phase I | MCC_Enabled_SG_<c1> | False      |
    And I take a screenshot
    And I navigate to "Upload Sites" page from "Manage Users" page
    When In MCCAdmin I upload a site csv spreadsheet named "mcc_test_sites.csv" from the upload sites page
    And I take a screenshot
    Then In MCCAdmin I verify the values for the following Sites:
      | Medical Facility Name         | Medinova Hospital            |
      | Client Division Site Number   | cdsite<c4>                   |
      | Study Environment Site Number | site<c4>                     |
      | PI Email Address              | test_pi_user_<c4>@gmail.com  |
      | PI First Name                 | Neil                         |
      | PI Last Name                  | Armstrong                    |
      | PI Role                       | PI                           |
      | Environment                   | Development                  |
      | Site Name                     | Medinova Hospital            |
      | Street Address                | 1969 Lunar Blvd              |
      | City                          | Cincinnati                   |
      | State                         | Ohio                         |
      | Country                       | United States                |
      | Postal Code                   | 45201                        |
    And I logout from "MCCAdmin"
