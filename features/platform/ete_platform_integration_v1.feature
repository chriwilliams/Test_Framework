Feature: End to End Integration Test for MCCAdmin, Rave Architect, Gambit, Balance, Coder

  Description TBD.  Test integration between mccadmin, rave, balance, gambit, and other platform apps.

  Pre-testing Assumptions: An MCCAdmin-enabled Study Group.  A user with admin rights to this study group.  Roles are
  configured for this Client Division.

  Running the coder setup assumes a Coder Segment Admin role in MCC Admin has been created.
     #Ex:
     #  And I add a new configuration role with the following data:
     #   | Name                | Category                      | Apps                        | Rave Architect Roles     |Rave Architect Security                     |Permissions                                                   |Rave EDC    |Rave Modules    |
     #   | Coder Segment Admin | Dictionary Management/Coding  | Coder Sandbox, Rave, gambit | Project Admin Default    |Upgraded Users from pre-5.6 Installations   |client_divisions-edit_client_divisions, client_divisions-edit |Power User  |All Modules     |

  @Release2015.2.0
  @PB165396-001
  @Draft
  @PlatformService
  Scenario: Platform Gambit Rave Balance Coder Integration Test.

    Given I login to "iMedidata" as user "imd_admin_sqa"
    And I navigate to "MCCAdmin" for study group "MCC Platform IntegrationTest101" from iMedidata
    And I take a screenshot
    And I navigate to All Studies page and create study using the values below:
      | Protocol ID | Use Protocol ID | Study Name                      | Primary Indication       | Secondary Indication | Phase   | Configuration Type              | Test Study |
      | MCC_PID_<s> | False           | Platform_Integration_Study_<c3> | Intracerebral Hemorrhage | Acute Pancreatitis   | Phase I | MCC Platform IntegrationTest101 | False      |
    And I take a screenshot
    And In MCCAdmin I add new user to study "Platform_Integration_Study_<c3>" using the value below:
      | First | Last | Email                            | Environment | Roles |
      | Rave  | User | cloudadmiral+rave_user@gmail.com | Production  | EDC   |
    And In MCCAdmin I add new user to study "Platform_Integration_Study_<c3>" using the value below:
      | First   | Last | Email                           | Environment | Roles   |
      | Balance | User | cloudadmiral+bal_user@gmail.com | Production  | Balance |
    And In MCCAdmin I add new user to study "Platform_Integration_Study_<c3>" using the value below:
      | First | Last | Email                             | Environment | Roles       |
      | Coder | User | cloudadmiral+coder_user@gmail.com | Production  | Coder Admin |
    And I take a screenshot
    And In MCCAdmin I create study site using the values below:
      | Site Name             | Client Division Site Number | Site Number | Street Address | Zip | City | Country       | State | Study Environment | Principal Investigator Email | Principal Investigator First Name | Principal Investigator Last Name | Principal Investigator Role |
      | Medinova Hospital<c1> | MH-cd-<c2>                  | MH-SES-<c2> |                |     |      | United States |       | Production        | cloudadmiral+pi@gmail.com    | Admin PI                          | User-<c8>                        | PI                          |
    And I take a screenshot
    And In MCCAdmin I assign user to site using the values below:
      | User Email                       | Environment | Site Name             |
      | cloudadmiral+rave_user@gmail.com | Production  | Medinova Hospital<c1> |
    And I take a screenshot
    And In MCCAdmin I assign user to site using the values below:
      | User Email                      | Environment | Site Name             |
      | cloudadmiral+bal_user@gmail.com | Production  | Medinova Hospital<c1> |
    And I take a screenshot
    And In MCCAdmin I assign user to site using the values below:
      | User Email                        | Environment | Site Name             |
      | cloudadmiral+coder_user@gmail.com | Production  | Medinova Hospital<c1> |
    And I take a screenshot
    And I logout from "MCCAdmin"

#  @Release2015.2.0
#  @PB109125-002
#  @Draft
#  @Coder
#  Scenario: Coder Setup Steps.
#    Given I login to "imedidata" as user "codersuperuser"
#    And I navigate to "Coder" for study group "PlatformIntegrationTest01" from iMedidata
#    And I select segment "MedidataReserved1"
#    And I navigate to Admin page "Segment Management" for segment "MedidataReserved1"
#    And I enroll a new segment named "MCCAdmin Platform Integration" in Coder application
#    And I navigate to "Medidata Admin Console" page from Admin list
#    And I select segment "MCCADMIN_PLATFORM_INTEGRATION(MCCAdmin Platform Integration)" and dictionary "MedDRA (eng)"
#    And I add a license key with the following data:
#      | License Code | Start Date | End Date  |
#      | TEST321      | 4/29/2000  | 4/29/2050 |
#    And I roll out dictionary "MedDRA (eng)" with version "15"
#    And I create and assign workflow role named "Workflow Admin" on Workflow page
#    And I assign a workflow role to user "Coder Admin (coderadmin)" with role "Workflow Admin" for "Platform_Integration_Study_<c3>"
#    And I create and assign general role named "StudyAdmin" for security module "Page Study Security"
#    And I assign a general page study role to user "Coder Admin (coderadmin)" for module "Page Study Security" with role "StudyAdmin" for "Platform_Integration_Study_<c3>"
#    And I create and assign general role named "DictAdmin" for security module "Page Dictionary Security"
#    And I assign a general page dictionary role to user "coder_user" for module "Page Dictionary Security" with role "DictAdmin" for dictionary "All"
#    And I logout from "Coder"
#    And I login to "imedidata" as user "coder_user"
#    And I navigate to "Modules" for study "study_name" from iMedidata
#    And I navigate to User Administration in Rave
#    And I search for user in Rave using the values below:
#      | Last Name | Log In      | Site | Site Group | Role | Study                        | Environment | Authenticator |
#      |           | coderimport |      |            |      | Platform_Integration_Study_<c3> |             | internal      |
#    And I go to user details for "coderimport"
#    And in Rave I assign role "Coder Import User" and study "Platform_Integration_Study_<c3>" to user
#    And I logout from "Rave"

  @Release2015.2.0
  @PB165396-003
  @Draft
  @Balance
  Scenario: Perform Balance Setup for Platform Integration Test
    Given I login to "iMedidata" as user "bal_user"
    And I search for study "Platform_Integration_Study_<c3>"
    And I select app "BalanceSandbox" from search results
    And I am running the study design wizard having chosen options:
      | Study Design          | Randomization and Supplies Management |
      | Blinding Restrictions | Yes                                   |
      | Design Setup          | Start from scratch                    |
      | Randomization Type    | Dynamic Allocation                    |
      | Quarantining          | No                                    |
      | Enrollment Caps       | No                                    |

    # Rand Design Setup
    And In Balance I add arm "Test Arm 1" with a ratio of 1
    And In Balance I add arm "Test Arm 2" with a ratio of 1
    And I take a screenshot

    # Treatment Setup
    When In Balance I create article type with the following attributes:
      | Name | Fixitol 10mg |
    And In Balance I create article type with the following attributes:
      | Name | Fixitol 20mg |
    When In Balance I create a treatment "Treatment 1" with DND of "30" and a composition of "1XFixitol 10mg"
    When In Balance I create a treatment "Treatment 2" with DND of "30" and a composition of "1XFixitol 20mg"
    And I take a screenshot

    # Visit Schedule Setup
    When In Balance I create a visit schedule with 5 visits, an offset of 7, start window of 2, end window of 3, and rand visit 2
    And In Balance I update multiple visit names with values below:
      | Old Visit Name | New Visit Name      |
      | Visit 1        | Screening Visit     |
      | Visit 2        | Randomization Visit |
      | Visit 3        | Visit 1             |
      | Visit 4        | Visit 2             |
      | Visit 5        | Visit 3             |
    And I take a screenshot

    # Assign Treatments Setup
    When In Balance I assign treatment "Treatment 1" to a filter of:
      | Arm | Test Arm 1 |
    When In Balance I assign treatment "Treatment 2" to a filter of:
      | Arm | Test Arm 2 |
    And I take a screenshot

    # Setup Inventory Data
    When In Balance I upload packlist "packlist 1" containing 300 items with file path "features/balance/support/packlists/300-items-fixitol.csv"
    And I wait for "5" seconds

    # Create and release lot
    Then In Balance I create lot with options:
      | lot name    | lot one     |
      | expiry date | 31 Dec 2018 |
      | depot       | Depot1      |
    And In Balance I add items "Fixitol 10mg,Fixitol 20mg" to lot "lot one"
    And In Balance I release lot "lot one" with signature "test user"

    # Create and confirm shipment
    Then In Balance I create a manual shipment with origin "Depot1" and destination "site-01 - iSite 01 (Inactive)" containing articles:
      | Article Name | Quantity |
      | Fixitol 10mg | 25       |
      | Fixitol 20mg | 25       |
    And In Balance I wait 30 seconds for shipment "10001" to be generated
    And In Balance I confirm shipment "10001" received

    # Go Live
    Then In Balance I Go Live without flushing data
    And I take a screenshot
    And In Balance I follow the iMedidata Logo
    And I logout from "iMedidata"

  @Release2015.2.0
  @PB165396-004
  @Draft
  @Rave
  Scenario: Perform Rave Setup by uploading draft, then publishing and pushing to all sites
    Given I login to "iMedidata" as user "rave_user"
    And I verify the following apps can be accessed for study "Platform_Integration_Study_<c3>":
      | Apps         |
      | Rave Modules |
    And I navigate to "Rave Modules" for study "Platform_Integration_Study_<c3>" from iMedidata
    And I verify I am in Rave app on the Sites tab for site "site_name"
    And I navigate to Architect in Rave
    And I upload draft "Balance-Study-II_Draft_1.0.zip"
    And I navigate to Architect in Rave
    And I navigate to Project "Balance-Study-II" in Architect
    And I select Draft "Draft 1.0"
    And I Publish and Push Draft "Draft 1.0" as "ver1_<s>" in "Prod" environment to All sites
    And I logout from "Rave"
