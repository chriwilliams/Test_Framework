Feature: Functional test for MCC Admin and Platform service.

  Pre-testing Assumptions: Assuming User with admin role, Study-Group exists in iMedidata.

  @Release2014.2.0
  @Draft
  @PlatformService
  Scenario: Create a study in MCC Admin, then lock and unlock the same study.

    Given I login to "iMedidata" as user "imd_admin_sqa"
    And I navigate to "MCCAdmin" for study group "MCC Enabled SG-2289" from iMedidata
    And I take a screenshot
    And I navigate to All Studies page and create study using the values below:
      | Protocol ID | Use Protocol ID | Study Name    | Primary Indication       | Secondary Indication | Phase         | Configuration Type  | Test Study |
      | MCC_PID_<s> | False           | MCC_Study_<s> | Intracerebral Hemorrhage | Acute Pancreatitis   | Phase I Trial | MCC_Enabled_SG_<r4> | False      |
    And I take a screenshot
    And I navigate to "Edit Study" page from Manage Users page
    And I take a screenshot
    And I lock the study and esign as user "imd_admin_sqa"
    And I take a screenshot
    And I verify user cannot be added in Manage Users page
    And I take a screenshot
    And I navigate to All Studies page, unlock the study "MCC Study" and esign as user "imd_admin_sqa"
    And I take a screenshot
    And I navigate to All Studies page, deactivate the study "MCC Study" and esign as user "imd_admin_sqa"
    And I take a screenshot
    And I verify user cannot be added in Manage Users page
    And I take a screenshot
    And I navigate to "Edit Study" page from Manage Users page
    And I activate the study as user "imd_admin_sqa"
    And I take a screenshot
    And I logout from "MCCAdmin"
    And I take a screenshot
