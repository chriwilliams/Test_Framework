Feature: Smoke Test for MCC Admin - Navigation

  As an user with admin role, I am able to navigate through MCC Admin.

  Pre-testing Assumptions: A user with admin role for the client division.

  @Release2015.2.0
  @PB149535-001
  @smoketest
  @PlatformService
  Scenario: MCC Admin navigation smoke test

    Given I login to "iMedidata" as user "imd_admin_sqa"
    And In iMedidata I navigate to "MCCAdmin" for study group "MCC Autotest CD02"
    And In MCCAdmin I navigate to "Manage Client Division" page
    And I take a screenshot
    And In MCCAdmin I navigate to "Manage Users" page
    And I take a screenshot
    And In MCCAdmin I navigate to "Manage Sites" page
    And I take a screenshot
    And In MCCAdmin I navigate to "Manage Studies" page
    And I take a screenshot
    And In MCCAdmin I navigate to "Manage Roles" page
    And I take a screenshot
    And I logout from "MCCAdmin"
    And I take a screenshot
