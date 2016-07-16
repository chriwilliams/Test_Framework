Feature: End to End Integration Test for iMedidata and MCC Admin.

  Description TBD.  Test full integration between mccadmin, rave, balance, ravex, and other platform apps.

  Pre-testing Assumptions: You have an imedidata admin user who can create new mcc-enabled study groups.

  @Release2015.2.0
  @PB109125-001
  @Draft
  @PlatformService
  Scenario: Platform Full Integration Test.

    Given I login to "iMedidata" as user "imd_admin_sqa"
    And I navigate to iMedidata Admin page and create study group using the values below:
      | Name                               | OID             | Apps                                                                                                                          | Courses | Access MCCAdmin |
      | MCC_Enabled_PlatformIntegration01  | SG-MCC-OID-<s>  | Rave EDC, Rave Modules, RaveX, Slaad, Rave Architect Security, BalanceValidation, Design Optimization, Coder Validation |         | True            |
    And I navigate to "MCCAdmin" for study group "MCC_Enabled_PlatformIntegration01" from iMedidata
    And I navigate to Configuration Roles page and add roles using the values below:
      | Name      | Category                      | Apps                    | Roles                 |
      | PI        | Principal Investigator        | Rave EDC                | PI                    |
      | EDC       | Data Management               | Rave EDC                | Power User            |
      | Modules   | Clinical Study Manager        | Rave Modules            | All Modules           |
      | RaveX     | Data Management               | RaveX                  |                       |
      | Slaad     | Data Management               | Slaad                   |                       |
      | Architect | EDC Study Builder             | Rave Architect Security | Project Admin Default |
      | Balance   | Clinical Trial Supplies       | BalanceValidation       | System Administrator  |
      | Janus     | Data Management               | Design Optimization     |                       |
      | Coder     | Dictionary Management/Config  | Coder Validation        |                       |
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
    And I perform actions for invitations in iMedidata using the values below:
      | Name                | Invitation |
      | MCC_Enabled_SG_<c5> | Accept     |
    And I take a screenshot
    And I navigate to "MCCAdmin" for study group "MCC_Enabled_SG_<c5>" from iMedidata
    And I take a screenshot
    And I navigate to All Studies page and create study using the values below:
      | Protocol ID | Use Protocol ID | Study Name                   | Primary Indication       | Secondary Indication | Phase   | Configuration Type                 | Test Study |
      | MCC_PID_<s> | False           | Platform_Integration_Study01 | Intracerebral Hemorrhage | Acute Pancreatitis   | Phase I | MCC_Enabled_PlatformIntegration01  | False      |
    And I take a screenshot
    And In MCCAdmin I add new user to study "Platform_Integration_Study01" using the value below:
      | First   | Last | Email                              | Environment  | Roles                     |
      | Rave    | User | cloudadmiral+rave_user@gmail.com   | Production   | EDC, Modules, Architect   |
      | Balance | User | cloudadmiral+bal_user@gmail.com    | Production   | Balance                   |
      | RaveX   | User | cloudadmiral+ravex_user@gmail.com  | Production   | EDC, RaveX, Slaad, admin  |
      | Coder   | User | cloudadmiral+coder_user@gmail.com  | Production   | EDC, Coder                |
      | Design  | User | cloudadmiral+design_user@gmail.com | Production   | Janus                     |
    And I take a screenshot
    And In MCCAdmin I create study site using the values below:
      | Site Name          | Client Division Site Number | Site Number | Street Address | Zip | City | Country       | State | Study Environment | Principal Investigator Email | Principal Investigator First Name | Principal Investigator Last Name | Principal Investigator Role |
      | Medinova Hospital  | MH-cd-01                    | MH-SES-01   |                |     |      | United States |       | Production        | cloudadmiral_pi@gmail.com    | Admin PI                          | User-<c8>                        | PI                          |
    And I take a screenshot
    And In MCCAdmin I assign user to site using the values below:
      | User Email                         | Environment | Site Name         |
      | cloudadmiral+rave_user@gmail.com   | Production  | Medinova Hospital |
      | cloudadmiral+bal_user@gmail.com    | Production  | Medinova Hospital |
      | cloudadmiral+ravex_user@gmail.com  | Production  | Medinova Hospital |
      | cloudadmiral+coder_user@gmail.com  | Production  | Medinova Hospital |
      | cloudadmiral+design_user@gmail.com | Production  | Medinova Hospital |
    And I take a screenshot
    And I logout from "MCCAdmin"

    And I login to "iMedidata" as user "bal_user"
    And I perform actions for invitations in iMedidata using the values below:
      | Name                         | Environment | Invitation     |
      | Platform_Integration_Study01 | PROD        | Accept         |
    And I verify the following apps can be accessed for study "Platform_Integration_Study01":
      | Apps     |
      | Balance  |
    And I navigate to "Balance" for study "Platform_Integration_Study01" from iMedidata

    # and I do my balance design setup
    And I logout from "Balance"

    And I login to "iMedidata" as user "rave_user"
    And I perform actions for invitations in iMedidata using the values below:
      | Name                         | Environment | Invitation     |
      | Platform_Integration_Study01 | PROD        | Accept         |
    And I verify the following apps can be accessed for study "Platform_Integration_Study01":
      | Apps           |
      | Rave Architect |
    And I navigate to "Rave Architect" for study "Platform_Integration_Study01" from iMedidata
    # and I do my Rave draft setup
    And I logout from "Rave"

    And I login to "iMedidata" as user "rave_user"
    And I perform actions for invitations in iMedidata using the values below:
      | Name                         | Environment | Invitation     |
      | Platform_Integration_Study01 | PROD        | Accept         |
    And I verify the following apps can be accessed for study "Platform_Integration_Study01":
      | Apps           |
      | Rave EDC       |
    And I navigate to "Rave EDC" for study "Platform_Integration_Study01" from iMedidata
    # you can navigate to any app here, at this point, if you navigate to Rave EDC you will be on
    # the Study Site page in RaveX
    # beyond this step is TBD by RaveX, Rave
    And I logout from "Rave"

    And I login to "iMedidata" as user "ravex_user"
    And I perform actions for invitations in iMedidata using the values below:
      | Name                         | Environment | Invitation     |
      | Platform_Integration_Study01 | PROD        | Accept         |
    And I verify the following apps can be accessed for study "Platform_Integration_Study01":
      | Apps         |
      | RaveX       |
    And I navigate to "RaveX" for study "Platform_Integration_Study01" from iMedidata
