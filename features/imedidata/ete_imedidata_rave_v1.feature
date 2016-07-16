Feature: iMedidata End to End using Rave app.


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
  Scenario: iMedidata End to End using Rave App

    Given I login to "iMedidata" as user "imd_admin_sqa"
    And I navigate to iMedidata Admin page and create study group using the values below:
      | Name                | OID             | Apps | Courses            | Access MCCAdmin |
      | IMD_Enabled_SG_<c1> | SG-IMD-OID-<r2> |      | Test Sample Course | false           |
    And I take a screenshot
    And I invite a user with the values below:
      | Email                                    | Owner |
      | cloudadmiral+imd_sg_owner_<c2>@gmail.com | true  |
    And I logout from "iMedidata"
    And the user with email "cloudadmiral+imd_sg_owner_<c2>@gmail.com" activates the account using the required values below:
      | Username           | First | Last      | Phone        | Select Timezone         | Select Locale | Password | Security Question        | Answer |
      | imd_sg_owner_<c2>  | Admin | User-<c2> | 123-456-7890 | (GMT+00:00) - UTC - UTC | English       | Secret1! | What year were you born? | 1970   |
    And I take a screenshot
    And I perform actions for invitations in iMedidata using the values below:
      | Name                | Invitation |
      | IMD_Enabled_SG_<c1> | Accept     |
    And I navigate to iMedidata Manage Study Group page for "IMD_Enabled_SG_<c1>" and create study using the values below:
      | Protocol ID        | Study Name             | Environment |
      | iMedidata_PID_<r2> | iMedidata Rave Study03 | DEV         |
      | iMedidata_PID2<r2> | iMedidata Rave Study04 | DEV         |
    And I take a screenshot
    And I navigate to site page and create new site in iMedidata using the values below:
      | Study Name           | Site Name           | Site Number | StudySite Number |
      | iMedidata Rave Study03 | Mediflex Hospital | MF-<r4>     | MF-SES-<r4>      |
      | iMedidata Rave Study04 | NYC Test Clinic   | MF-<r4>     | MF-SES-<r4>      |
    And I logout from "iMedidata"
    And I login to "iMedidata" as user "imd_admin_sqa"
    And I navigate to Admin page and update the study group "IMD_Enabled_SG_<c1>" using the values below:
      | Apps                            |
      | Rave564conlabtesting16 Rave EDC |
    And I take a screenshot
    And I invite a user with the values below:
      | Email                                    | Owner | Apps                            | Roles    |
      | cloudadmiral+imd_sg_owner_<c2>@gmail.com | true  | Rave564conlabtesting16 Rave EDC | cdm1_mcc |
    And I take a screenshot
    And I logout from "iMedidata"
    And I login to iMedidata as newly created user "imd_sg_owner_<c2>"
    And I take a screenshot
    And I search for a study group "IMD_Enabled_SG_<c1>" and navigate to Manage Study Group page
    And I select eLearning tab for study group "IMD_Enabled_SG_<c1>" in Manage Study Group page
    And I map the course using the values below:
      | Course              | Apps                            | Roles     | Required |
      | Test Sample Course  | Rave564conlabtesting16 Rave EDC | crc1_mcc  | true     |
    And I search for a study "iMedidata Rave Study03" and navigate to Manage Study page
    And I invite a user with the values below:
      | Email                                      | Owner | Apps                            | Roles    |
      | cloudadmiral+imd_study_user_<c7>@gmail.com | true  | Rave564conlabtesting16 Rave EDC | crc1_mcc |
    And I take a screenshot
    And I assign Sites using the values below:
      | Search Field                               | Site Name         | Access |
      | cloudadmiral+imd_study_user_<c7>@gmail.com | Mediflex Hospital | Owner  |
    And I search for a study "iMedidata Rave Study04" and navigate to Manage Study page
    And I invite a user with the values below:
      | Email                                      | Owner | Apps                            | Roles    |
      | cloudadmiral+imd_study_user_<c7>@gmail.com | true  | Rave564conlabtesting16 Rave EDC | crc1_mcc |
    And I assign Sites using the values below:
      | Search Field                               | Site Name       | Access |
      | cloudadmiral+imd_study_user_<c7>@gmail.com | NYC Test Clinic | Owner  |
    And I logout from "iMedidata"
    And the user with email "cloudadmiral+imd_study_user_<c7>@gmail.com" activates the account using the required values below:
      | Username            | First | Last | Phone        | Select Timezone         | Select Locale | Password | Security Question        | Answer |
      | imd_study_user_<c7> | Study | User | 123-456-7890 | (GMT+00:00) - UTC - UTC | English       | Secret1! | What year were you born? | 1970   |
    And I perform actions for invitations in iMedidata using the values below:
      | Name                   | Environment | Invitation |
      | iMedidata Rave Study03 | DEV         | Accept     |
      | iMedidata Rave Study04 | DEV         | Accept     |
    And I verify the course "Test Sample Course" is blocking app access for study "iMedidata Rave Study03 (DEV)"
    And I verify the course "Test Sample Course" is blocking app access for study "iMedidata Rave Study04 (DEV)"
    And I take a screenshot
    And I logout from "iMedidata"
    And I login to iMedidata as newly created user "imd_sg_owner_<c2>"
    And I take a screenshot
    And I search for a study "iMedidata Rave Study03" and navigate to Manage Study page
    And I take a screenshot
    And I search for the invited user "cloudadmiral+imd_study_user_<c7>@gmail.com" on iMedidata Manage Study Page
    And I take a screenshot
    And I override a course for the user "imd_study_user_<c7>"
      | Course              | Reason         |
      | Test Sample Course  | Testing course |
    And I take a screenshot
    And I logout from "iMedidata"
    And I login to iMedidata as newly created user "imd_study_user_<c7>"
    And I take a screenshot
    And I verify the course "Test Sample Course" is not blocking app access for study "iMedidata Rave Study03 (DEV)"
    And I verify the course "Test Sample Course" is blocking app access for study "iMedidata Rave Study04 (DEV)"
    And I logout from "iMedidata"
    And I login to iMedidata as newly created user "imd_sg_owner_<c2>"
    And I search for a study "iMedidata Rave Study04" and navigate to Manage Study page
    And I change the app-role assignment for user "imd_study_user_<c7>"
      | App                             | Role      | NewRole  |
      | Rave564conlabtesting16 Rave EDC | crc1_mcc  | cra1_mcc |
    And I take a screenshot
    And I logout from "iMedidata"
    And I login to iMedidata as newly created user "imd_study_user_<c7>"
    And I take a screenshot
    And I verify the following apps can be accessed for study "iMedidata Rave Study04 (DEV)":
      | Apps                            |
      | Rave564conlabtesting16 Rave EDC |
    And I navigate to "Rave EDC" for study "iMedidata Rave Study04" from iMedidata
    And I take a screenshot
    And I verify I am in Rave app on the Sites tab for site "NYC Test Clinic"
    And I logout from "Rave"
    And I take a screenshot
