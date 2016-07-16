Feature: iMedidata End to End Core Scenario


  As an user with admin role, I should be able to create study groups, assign apps and courses to study groups in iMedidata.
  As study group owner, I should also be able to create study, create user, map and override courses, assign roles and study environments, create site and assign user to sites.
  As a study owner, I should be able to activate account, take required course via e-learning, complete the e-learning providing correct e-signature, access and navigate to study group, study and study environment/s depending on role assignment.

  @Release2014.2.0
  @PB112962-001
  @Draft
  @selenium
  @iMedidata
  Scenario: iMedidata End to End Core.

    Given I login to "iMedidata" as user "imd_admin_sqa"
    And I navigate to iMedidata Admin page and create study group using the values below:
      | Name                | OID             | Courses            | Access MCCAdmin |
      | IMD_Enabled_SG_<c1> | SG-IMD-OID-<r2> | Test Sample Course | false           |
    And I take a screenshot
    And I invite a user with the values below:
      | Email                                    | Owner |
      | cloudadmiral+imd_sg_owner_<c2>@gmail.com | true  |
    And I logout from "iMedidata"
    And the user with email "cloudadmiral+imd_sg_owner_<c2>@gmail.com" activates the account using the required values below:
      | Username           | First | Last      | Phone        | Select Timezone         | Select Locale | Password | Security Question        | Answer |
      | imd_sg_owner_<c2>  | Admin | User-<c2> | 123-456-7890 | (GMT+00:00) - UTC - UTC | English       | Secret1! | What year were you born? | 1970   |
    And I take a screenshot
    And In iMedidata I accept invitation for "IMD_Enabled_SG_<c1>"
    And I navigate to iMedidata Manage Study Group page for "IMD_Enabled_SG_<c1>" and create study using the values below:
      | Protocol ID        | Study Name           | Environment |
      | iMedidata_PID_<r2> | iMedidata CI Study05 | DEV         |
      | iMedidata_PID2<r2> | iMedidata CI Study06 | DEV         |
    And I take a screenshot
    And I navigate to site page and create new site in iMedidata using the values below:
      | Study Name           | Site Name         | Site Number | StudySite Number |
      | iMedidata CI Study05 | Mediflex Hospital | MF-<r4>     | MF-SES-<r4>      |
      | iMedidata CI Study06 | NYC Test Clinic   | MF-<r4>     | MF-SES-<r4>      |
    And I logout from "iMedidata"
    And I login to "iMedidata" as user "imd_admin_sqa"
    And I navigate to Admin page and update the study group "IMD_Enabled_SG_<c1>" using the values below:
      | Apps         |
      | Test App-MCC |
    And I take a screenshot
    And I invite a user with the values below:
      | Email                                    | Owner | Apps         | Roles    |
      | cloudadmiral+imd_sg_owner_<c2>@gmail.com | true  | Test App-MCC | cdm1_mcc |
    And I take a screenshot
    And I logout from "iMedidata"
    And I login to iMedidata as newly created user "imd_sg_owner_<c2>"
    And I take a screenshot
    And I search for a study group "IMD_Enabled_SG_<c1>" and navigate to Manage Study Group page
    And I select eLearning tab for study group "IMD_Enabled_SG_<c1>" in Manage Study Group page
    And I map the course using the values below:
      | Course              | Apps         | Roles    | Required |
      | Test Sample Course  | Test App-MCC | crc1_mcc | true     |
    And I search for a study "iMedidata CI Study05" and navigate to Manage Study page
    And I invite a user with the values below:
      | Email                                      | Owner | Apps         | Roles    |
      | cloudadmiral+imd_study_user_<c7>@gmail.com | true  | Test App-MCC | crc1_mcc |
    And I take a screenshot
    And I assign Sites using the values below:
      | Search Field                               | Site Name         | Access |
      | cloudadmiral+imd_study_user_<c7>@gmail.com | Mediflex Hospital | Owner  |
    And I search for a study "iMedidata CI Study06" and navigate to Manage Study page
    And I invite a user with the values below:
      | Email                                      | Owner | Apps         | Roles    |
      | cloudadmiral+imd_study_user_<c7>@gmail.com | true  | Test App-MCC | crc1_mcc |
    And I assign Sites using the values below:
      | Search Field                               | Site Name       | Access |
      | cloudadmiral+imd_study_user_<c7>@gmail.com | NYC Test Clinic | Owner  |
    And I logout from "iMedidata"
    And the user with email "cloudadmiral+imd_study_user_<c7>@gmail.com" activates the account using the required values below:
      | Username            | First | Last | Phone        | Select Timezone         | Select Locale | Password | Security Question        | Answer |
      | imd_study_user_<c7> | Study | User | 123-456-7890 | (GMT+00:00) - UTC - UTC | English       | Secret1! | What year were you born? | 1970   |
    And In iMedidata I acknowledge invitations for the following studies:
      | Name                       | Invitation |
      | iMedidata CI Study05 (DEV) | accept     |
      | iMedidata CI Study06 (DEV) | accept     |
    And I verify the course "Test Sample Course" is blocking app access for study "iMedidata CI Study05 (DEV)"
    And I verify the course "Test Sample Course" is blocking app access for study "iMedidata CI Study06 (DEV)"
    And I take a screenshot
    And I logout from "iMedidata"
    And I login to iMedidata as newly created user "imd_sg_owner_<c2>"
    And I take a screenshot
    And I search for a study "iMedidata CI Study05" and navigate to Manage Study page
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
    And I verify the course "Test Sample Course" is not blocking app access for study "iMedidata CI Study05 (DEV)"
    And I verify the course "Test Sample Course" is blocking app access for study "iMedidata CI Study06 (DEV)"
    And I logout from "iMedidata"
    And I login to iMedidata as newly created user "imd_sg_owner_<c2>"
    And I search for a study "iMedidata CI Study06" and navigate to Manage Study page
    And I change the app-role assignment for user "imd_study_user_<c7>"
      | App          | Role      | NewRole   |
      | Test App-MCC | crc1_mcc  | cra1_mcc  |
    And I take a screenshot
    And I logout from "iMedidata"
    And I login to iMedidata as newly created user "imd_study_user_<c7>"
    And I verify the course "Test Sample Course" is not blocking app access for study "iMedidata CI Study06 (DEV)"
    And I verify the following apps can be accessed for study "iMedidata CI Study06 (DEV)":
      | Apps         |
      | Test App-MCC |
    And I take a screenshot
    And I logout from "iMedidata"
    And I take a screenshot
