Feature: MCC Admin user upload functional test.

  As an user with admin role, I should be a able to upload users to a MCC study within a client division.

  Pre-testing Assumptions: A mcc-enabled study group.  A user with 'admin' role for the client division.  Study Sites will
    exist in all environments.

  @Release2015.2.0
  @Draft
  @PlatformService
  Scenario: As a client division admin user, I am able to create a new study and upload users.

    Given I create a csv spreadsheet named "mcc_test_users.csv" with values below:
      | Email             | cloudadmiral+uploaduser<c4>@mdsol.com |
      | First Name        | Peter                                 |
      | Last Name         | Parker                                |
      | Role              | CRA                                   |
      | Environment       | Production                            |
      | Phone Number      | 212-555-8888                          |
      | Site              | autosite 1                            |
    And I login to "iMedidata" as user "mcc_admin_sqa"
    And I navigate to "MCCAdmin" for study "MCC_User_Study_01" from iMedidata
    And I navigate to "Upload Users" page from "Manage Users" page
    When In MCCAdmin I upload a user csv spreadsheet named "mcc_test_users.csv" from the upload users page
    And I take a screenshot
    Then In MCCAdmin I verify the values for the following Users:
      | Email             | cloudadmiral+uploaduser<c4>@mdsol.com |
      | First Name        | Peter                                 |
      | Last Name         | Parker                                |
      | Role              | CRA                                   |
      | Environment       | Production                            |
      | Phone Number      | 212-555-8888                          |
      | Site              | autosite 1                            |
    And I logout from "MCCAdmin"
