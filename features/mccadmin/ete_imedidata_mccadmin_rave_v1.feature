Feature: iMedidata End to End.


  As an user with admin role, I should be able to create courses, create study groups, assign apps and courses to study groups in iMedidata.
  I should also be able to create study, create user, assign roles and study environments, create site and assign user to sites.

  As an authorized user, I should be able to activate account, take required course via e-learning, complete the e-learning providing correct e-signature,
  access and navigate to study group, study and study environment/s depending on role assignment.
  I should also be able to navigate to Rave and access the study group, study and site.

  Pre-testing assumptions: admin user should exist before the test execution in the system.
  Study Group/Study owner should not exist before test execution and should be created during the test.

  @Release2014.2.0
  @Draft
  @iMedidata
  Scenario: iMedidata End to End.

    Given I login to "iMedidata" as user "imd_admin_sqa"
    And I navigate to iMedidata Admin page and create study group using the values below:
      | Name                | OID             | Apps                                | Courses            | Access MCCAdmin |
      | MCC_Enabled_SG_<c1> | SG-IMD-OID-<r2> | Rave EDC - conlabtesting71 Rave EDC | Test Sample Course | True            |
    And I take a screenshot
    And I navigate to "MCCAdmin" for study group "MCC_Enabled_SG_<c1>" from iMedidata
    And I take a screenshot
    And I navigate to Configuration Roles page and add roles using the values below:
      | Name  | Category                      | Apps     | Roles    |
      | CO    | Clinical Operations           | Rave EDC | cdm1_mcc |
      | PI    | Principal Investigator        | Rave EDC | pi1_mcc  |
      | CRA   | Clinical Research Associate   | Rave EDC | cra1_mcc |
      | CRC   | Clinical Research Coordinator | Rave EDC | crc1_mcc |
    And I take a screenshot
    And I navigate to Client Division Users page and create admin user using the values below:
      | Email                                | First | Last      | Role  |
      | cloudadmiral+cd_admin_<c2>@gmail.com | Admin | User-<c2> | admin |
    And I logout from "MCCAdmin"
    And I take a screenshot
    And the user with email "cloudadmiral+cd_admin_<c2>@gmail.com" activates the account using the required values below:
      | Username       | First | Last      | Phone        | Select Timezone         | Select Locale | Password | Security Question        | Answer |
      | cd_admin_<c2>  | Admin | User-<c2> | 123-456-7890 | (GMT+00:00) - UTC - UTC | English       | Secret1! | What year were you born? | 1970   |
    And I take a screenshot
    And I perform actions for invitations in iMedidata using the values below:
      | Name                | Invitation |
      | MCC_Enabled_SG_<c1> | Accept     |
    And I navigate to "MCCAdmin" for study group "MCC_Enabled_SG_<c1>" from iMedidata
    And I navigate to All Studies page and create study using the values below:
      | Protocol ID | Use Protocol ID | Study Name       | Primary Indication       | Secondary Indication | Phase   | Configuration Type  | Test Study |
      | MCC_PID_<s> | False           | MCC_Study_Auto01 | Intracerebral Hemorrhage | Acute Pancreatitis   | Phase I | MCC_Enabled_SG_<c1> | False      |
    And I take a screenshot
    And I navigate to iMedidata elearning page from MCCAdmin "Manage Users" page
    And I take a screenshot
    And I map the course using the values below:
      | Course             | Apps     | Roles    |
      | Test Sample Course | Rave EDC | cra1_mcc |
    And I take a screenshot
    And I navigate to MCCAdmin "All Studies" page from iMedidata Manage Study Group page
    And I navigate to Manage Users page for study "MCC_Study_Auto01" and add user using the values below:
      | First   | Last      | Email                                | Environment             | Roles    |
      | Regular | User-<c4> | cloudadmiral+reg_user_<c4>@gmail.com | Development, Production | CRA, CRC |
    And I take a screenshot
    And I navigate to Add Site page and create site using the values below:
      | Site Name              | Client Division Site Number | Site Number | Street Address | Zip   | City     | Country       | State    | Study Environment | Principal Investigator Email | Principal Investigator First Name | Principal Investigator Last Name | Principal Investigator Role |
      | Medinova Test Hospital | MH-CDS-<c5>                 | MH-SES-<c5> | 350 East St    | 10014 | New York | United States | New York | Development       | mrahman+pi_<c8>@mdsol.com    | Admin PI                          | User-<c8>                        | PI                          |
    And I take a screenshot
    And I navigate to Manage Users page and assign user to site using the values below:
      | User Email                           | Environment | Site Name              |
      | cloudadmiral+reg_user_<c4>@gmail.com | Development | Medinova Test Hospital |
    And I take a screenshot
    And I logout from "MCCAdmin"
    And I take a screenshot
    And the user with email "cloudadmiral+reg_user_<c4>@gmail.com" activates the account using the required values below:
      | Username      | First   | Last      | Phone        | Select Timezone         | Select Locale | Password | Security Question        | Answer |
      | reg_user_<c4> | Regular | User-<c4> | 098-765-4321 | (GMT+00:00) - UTC - UTC | English       | Secret2! | What year were you born? | 1990   |
    And I take a screenshot
    And I perform actions for invitations in iMedidata using the values below:
      | Name             | Environment | Invitation     |
      | MCC_Study_Auto01 | DEV, PROD   | Accept, Accept |
    And I take a screenshot
    And I verify the course "Test Sample Course" is not blocking app access for study "MCC_Study_Auto01"
    And I verify the course "Test Sample Course" is blocking app access for study "MCC_Study_Auto01 (DEV)"
    And I complete the course "Test Sample Course" for study "MCC_Study_Auto01 (DEV)" and e-sign
    And I verify the following apps can be accessed for study "MCC_Study_Auto01 (DEV)":
      | Apps     |
      | Rave EDC |
    And I take a screenshot
    And I logout from "MCCAdmin"
