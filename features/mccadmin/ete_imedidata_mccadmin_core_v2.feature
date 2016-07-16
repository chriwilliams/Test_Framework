Feature: End to End Integration Test for iMedidata and MCC Admin.

  As an user with admin role, I should be able to create courses, create study groups, assign apps and courses to study groups in iMedidata. I should also be able to create study, create user, assign roles and study environments, create site and assign user to sites in MCC Admin.
  As an authorized user, I should be able to activate account, take required course via e-learning, complete the e-learning providing correct e-signature, access and navigate to study group, study and study environment/s depending on role assignment.

  Pre-testing Assumptions: Assuming User with admin role, apps and Test Sample Course, exists in iMedidata.

  @Release2015.2.0
  @PB109125-001
  @Draft
  @selenium
  @PlatformService
  Scenario: iMedidata Service Integration Test.
    Given I have the following data set:
      | Key                   | Value                                |
      | site_01               | MediSite<r6>                         |
      | cd_site_number01      | cdsite<r6>                           |
      | site_number01         | site<r6>                             |
      | pi_email              | cloudadmiral+pi<r6>@gmail.com        |
      | pi_last               | Lname<r6>                            |
      | test_sg_name          | MCC_PlatformIntegration_<r6>         |
      | test_sg_oid           | SG-MCC-OID-<r6>                      |
      | test_study_name       | Platform_Integration_Study<r6>       |
      | test_study_protocol   | MCC_PID<r6>                          |
      | cd_user01_last        | Cdlname<r6>                          |
      | cd_user01_email       | cloudadmiral+cdadmin<r6>@gmail.com   |
      | cd_user01_username    | cd_user_<r6>                         |
      | study_user01_last     | Studylname<r6>                       |
      | study_user01_email    | cloudadmiral+studyuser<r6>@gmail.com |
      | study_user01_username | study_user<r6>                       |

    And I login to "iMedidata" as user "imd_admin_sqa"
    And In iMedidata I create a study group using the values below:
      | Name         | OID         | Apps         | Courses            | Access MCCAdmin |
      | test_sg_name | test_sg_oid | Test App-MCC | Test Sample Course | True            |
    And I take a screenshot
    And In iMedidata I navigate to "MCCAdmin" for study group "test_sg_name"
    And I take a screenshot
    And In MCCAdmin navigate to Configuration Roles page and add roles using the values below:
      | Name | Category                      | Apps         | Roles    |
      | PI   | Principal Investigator        | Test App-MCC | pi1_mcc  |
      | CRA  | Clinical Research Associate   | Test App-MCC | cra1_mcc |
      | CRC  | Clinical Research Coordinator | Test App-MCC | crc1_mcc |
    And I take a screenshot
    And I navigate to Client Division Users page and create admin user using the values below:
      | Email           | First | Last           | Role  |
      | cd_user01_email | Admin | cd_user01_last | Admin |
    And I take a screenshot
    And I logout from "MCCAdmin"
    And the user with email "cloudadmiral+cd_user_<c2>@gmail.com" activates the account using the required values below:
      | Username           | First | Last           | Phone        | Select Timezone         | Select Locale | Password | Security Question        | Answer |
      | cd_user01_username | Admin | cd_user01_last | 123-456-7890 | (GMT+00:00) - UTC - UTC | English       | Secret1! | What year were you born? | 1970   |
    And I take a screenshot
    And In iMedidata I navigate to "MCCAdmin" for study group "test_sg_name"
    And I take a screenshot
    And In MCCAdmin I create a study using the values below:
      | Protocol ID         | Use Protocol ID | Study Name      | Primary Indication       | Secondary Indication | Phase   | Configuration Type | Test Study |
      | test_study_protocol | False           | test_study_name | Intracerebral Hemorrhage | Acute Pancreatitis   | Phase I | test_sg_name       | False      |
    And I take a screenshot
    And In MCCAdmin I create study site using the values below:
      | Site Name | Client Division Site Number | Site Number   | Street Address | Zip | City | Country       | State | Study Environment | Principal Investigator Email | Principal Investigator First Name | Principal Investigator Last Name | Principal Investigator Role |
      | site_01   | cd_site_number01            | site_number01 |                |     |      | United States |       | Production        | pi_email                     | Admin PI                          | pi_last                          | PI                          |
    And I take a screenshot
    And In MCCAdmin I create study site using the values below:
      | Site Name | Client Division Site Number | Site Number   | Street Address | Zip | City | Country       | State | Study Environment | Principal Investigator Email | Principal Investigator First Name | Principal Investigator Last Name | Principal Investigator Role |
      | site_02   | cd_site_number02            | site_number02 |                |     |      | United States |       | Development       | pi_email                     | Admin PI                          | pi_last                          | PI                          |
    And I navigate to iMedidata elearning page from MCCAdmin
    And I take a screenshot
    And I map the course using the values below:
      | Course             | Apps         | Roles    |
      | Test Sample Course | Test App-MCC | cra1_mcc |
    And I take a screenshot
    And I navigate to MCCAdmin "All Studies" page from iMedidata Manage Study Group page
    And I take a screenshot
    And I search for study "test_study_name" in MCCAdmin
    And I take a screenshot
    And In MCCAdmin I add new user to study "test_study_name" using the value below:
      | First   | Last              | Email              | Environment             | Roles    |
      | Regular | study_user01_last | study_user01_email | Development, Production | CRA, CRC |
    And I take a screenshot
    And In MCCAdmin I assign user to site using the values below:
      | User Email         | Environment | Site Name |
      | study_user01_email | Production  | site_01   |
    And In MCCAdmin I assign user to site using the values below:
      | User Email         | Environment | Site Name |
      | study_user01_email | Development | site_02   |
    And I take a screenshot
    And I logout from "MCCAdmin"
    And the user with email "cloudadmiral+reg_user_<c4>@gmail.com" activates the account using the required values below:
      | Username               | First   | Last      | Phone        | Select Timezone         | Select Locale | Password | Security Question        | Answer |
      | study_user01_username  | Regular | User-<c4> | 098-765-4321 | (GMT+00:00) - UTC - UTC | English       | Secret2! | What year were you born? | 1990   |
    And I take a screenshot
    And I verify the course "Test Sample Course" is not blocking app access for study "MCC_Study_<c3>"
    And I verify the course "Test Sample Course" is blocking app access for study "MCC_Study_<c3> (DEV)"
    And I complete the course "Test Sample Course" for study "MCC_Study_<c3> (DEV)" and e-sign
    And I verify the following apps can be accessed for study "MCC_Study_<c3> (DEV)":
      | Apps         |
      | Test App-MCC |
    And I take a screenshot
    And I logout from "iMedidata"
    And I take a screenshot
