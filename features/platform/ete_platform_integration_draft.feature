Feature: End to End Integration Test for MCCAdmin, Rave Architect, Gambit, Balance, Coder

  Description TBD.  Test integration between mccadmin, rave, balance, gambit, and other platform apps.

  Pre-testing Assumptions: An MCCAdmin-enabled Study Group.  A user with admin rights to this study group.  Roles are
  configured for this Client Division.

  Running the coder setup assumes a Coder Segment Admin role in MCC Admin has been created.

  @Draft
  @PlatformService
  Scenario: Platform Gambit Rave Balance Coder Integration Test.

    Given I login to "iMedidata" as user "imd_admin_sqa"
    And I navigate to iMedidata Admin page and create study group using the values below:
      | Name                                  | OID             | Apps                                                                                                              | Courses | Access MCCAdmin |
      | MCC_Enabled_PlatformIntegration_<c1>  | SG-MCC-OID-<s>  | Rave EDC, Rave Modules, RaveX, Slaad, Rave Architect Security, BalanceSandbox, Design Optimization, Coder Sandbox |         | True            |
    And I navigate to "MCCAdmin" for study group "MCC_Enabled_PlatformIntegration_<c1>" from iMedidata
    And I navigate to All Studies page and create study using the values below:
      | Protocol ID | Use Protocol ID | Study Name                      | Primary Indication       | Secondary Indication | Phase   | Configuration Type                    | Test Study |
      | MCC_PID_<s> | False           | Platform_Integration_Study_<c3> | Intracerebral Hemorrhage | Acute Pancreatitis   | Phase I | MCC_Enabled_PlatformIntegration_<c1>  | False      |
    And I take a screenshot
    And In MCCAdmin I create study site using the values below:
      | Site Name          | Client Division Site Number | Site Number | Street Address | Zip | City | Country       | State | Study Environment | Principal Investigator Email | Principal Investigator First Name | Principal Investigator Last Name | Principal Investigator Role |
      | Medinova Hospital  | MH-cd-01                    | MH-SES-01   |                |     |      | United States |       | Production        | cloudadmiral_pi@gmail.com    | Admin PI                          | User-<c8>                        | PI                          |
    And I take a screenshot
    And I navigate to Configuration Roles page and add roles using the values below:
      | Name      | Category                      | Apps                    | Roles                 |
      | PI        | Principal Investigator        | Rave EDC                | PI                    |
      | EDC       | Data Management               | Rave EDC                | Power User            |
      | Modules   | Clinical Study Manager        | Rave Modules            | All Modules           |
      | RaveX     | Data Management               | RaveX                   |                       |
      | Slaad     | Data Management               | Slaad                   |                       |
      | Architect | EDC Study Builder             | Rave Architect Security | Project Admin Default |
      | Balance   | Clinical Trial Supplies       | BalanceSandbox          | System Administrator  |
      | Janus     | Data Management               | Design Optimization     |                       |
      | Coder     | Dictionary Management/Config  | Coder Sandbox           |                       |
    #adding steps for creating the Coder Segment Admin Role
    And I add a new configuration role with the following data:
       | Name                | Category                      | Apps                        | Rave Architect Roles     |Rave Architect Security                     |Permissions                                                   |Rave EDC    |Rave Modules    |
       | Coder Segment Admin | Dictionary Management/Coding  | Coder Sandbox, Rave, gambit | Project Admin Default    |Upgraded Users from pre-5.6 Installations   |client_divisions-edit_client_divisions, client_divisions-edit |Power User  |All Modules     |
    And In Role Configuration I navigate to app "Admin"
    And I navigate to Client Division Users page and create admin user using the values below:
      | Email                                | First | Last      | Role  |
      | cloudadmiral+cd_user_<c2>@gmail.com  | Admin | User-<c2> | admin |
    And I take a screenshot
    And I logout from "MCCAdmin"
    And the user with email "cloudadmiral+cd_user_<c2>@gmail.com" activates the account using the required values below:
      | Username     | First | Last      | Phone        | Select Timezone         | Select Locale | Password | Security Question        | Answer |
      | cd_user_<c2> | Admin | User-<c2> | 123-456-7890 | (GMT+00:00) - UTC - UTC | English       | Secret1! | What year were you born? | 1970   |
    And I take a screenshot
    And I navigate to "MCCAdmin" for study group "MCC_Enabled_PlatformIntegration_<c1>" from iMedidata
    And I take a screenshot
    And In MCCAdmin I add new user to study "Platform_Integration_Study_<c3>" using the value below:
      | First   | Last | Email                              | Environment  | Roles                     |
      | Rave    | User | cloudadmiral+rave_user@gmail.com   | Production   | EDC, Modules, Architect   |
      | Balance | User | cloudadmiral+bal_user@gmail.com    | Production   | Balance                   |
      | RaveX   | User | cloudadmiral+ravex_user@gmail.com  | Production   | EDC, RaveX, Slaad, admin  |
      | Coder   | User | cloudadmiral+coder_user@gmail.com  | Production   | EDC, Coder                |
      | Design  | User | cloudadmiral+design_user@gmail.com | Production   | Janus                     |
    And I take a screenshot
    And In MCCAdmin I assign user to site using the values below:
      | User Email                         | Environment | Site Name         |
      | cloudadmiral+rave_user@gmail.com   | Production  | Medinova Hospital |
      | cloudadmiral+bal_user@gmail.com    | Production  | Medinova Hospital |
      | cloudadmiral+ravex_user@gmail.com  | Production  | Medinova Hospital |
      | cloudadmiral+coder_user@gmail.com  | Production  | Medinova Hospital |
      | cloudadmiral+design_user@gmail.com | Production  | Medinova Hospital |
    And I take a screenshot
    #Creation and addition of Depots to the selected study
    And In MCCAdmin I select environment "Production" from the filter group
    And In MCCAdmin I navigate to "Manage Depots" page
    And In iMedidata I create depots with the following attributes:
      | Depot Name  |  Number     |  Country        |
      | Depot_<c1>  |  <c1>       |  United States  |
    And I logout from "MCCAdmin"
