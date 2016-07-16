Feature: This feature tests the functionality of the "Cannot Save in Production" flag in Rave-iMedidata.

  Background: I have the data already setup
    Given I have the following data set:
      | Key           | Value                  |
      | study_name    | TestStudyCreate1       |
      | study_dev     | TestStudyCreate1 (DEV) |
      | site_name     | Test1                  |
      | password      | password               |
      | user_password | Password1              |

  @Validation
  @Release2014.2.0
  @PB-111358-01
  Scenario: When an iMedidata user's account with "Cannot Save in Production" checked is linked to Rave, then "Cannot Save in Production" flag in Rave should be checked and user should not be able to save data in production from Rave.
    Given I login to "rave" as user "defuser"
    And I add a subject for study "study_name" and site "site_name" with following values:
      | Field Name  | Type | Value |
      | Subject ID: | text | 1_<l> |
    And I take a screenshot
    And I logout from "rave"
    Given I login to "imedidata" as user "helpdeskuser"
    Given Cannot Save in Production flag for email "cloudadmiral+user_001@gmail.com" is checked in iMedidata
    And I logout from "imedidata"
    Given I login to "imedidata" as user "user_001"
    And In iMedidata I navigate to "Rave EDC" for study "study_name"
    And I search for user in Rave using the values below:
      | Last Name | Log In   | Site | Site Group | Role | Study      | Authenticator |
      |           | user_001 |      |            |      | study_name | iMedidata     |
    And I go to user details for "user_001"
    Then In Rave I verify Cannot Save in Production checkbox is checked
    And I verify text "When selected, save is disabled in production" exists on User Details page in Rave
    And I take a screenshot
    And I search for subject "sub_name" for study named "study_name" and site "site_name"
    And I navigate to form "Form1" in Rave
    Then I verify Save button is disabled
    Then I verify Sign and Save button is disabled
    And I verify text "Saving is disabled. Contact Medidata Customer Care at tollfree.mdsol.com for assistance." is available of EDC page
    And I take a screenshot
    And I enter the following data for the "Form1" Rave form:
      | Field Name | Type | Value |
      | First Name | text | FName |
      | Last Name  | text | LName |
    Then I verify Save button is disabled
    Then I verify Sign and Save button is disabled
    And I verify text "Saving is disabled. Contact Medidata Customer Care at tollfree.mdsol.com for assistance." is available of EDC page
    And I take a screenshot
    And I cancel Rave EDC form
    And I logout from "rave"

  @Validation
  @Release2014.2.0
  @PB-111358-02
  Scenario: When an iMedidata user’s account with  "Cannot Save in Production" unchecked is linked to Rave, then "Cannot Save in Production" flag  in Rave should be unchecked and user should be able to save data in production form Rave.
    Given I login to "rave" as user "defuser"
    And I add a subject for study "study_name" and site "site_name" with following values:
      | Field Name  | Type | Value |
      | Subject ID: | text | 2_<l> |
    And I take a screenshot
    And I logout from "rave"
    And I login to "imedidata" as user "helpdeskuser"
    And I navigate to Helpdesk in iMedidata
    Given Cannot Save in Production flag for email "cloudadmiral+user_002@gmail.com" is unchecked in iMedidata
    And I logout from "imedidata"
    And I login to "imedidata" as user "user_002"
    And In iMedidata I navigate to "Rave EDC" for study "study_name"
    And I search for user in Rave using the values below:
      | Last Name | Log In   | Site | Site Group | Role | Study      | Authenticator |
      |           | user_002 |      |            |      | study_name | iMedidata     |
    And I go to user details for "user_002"
    Then In Rave I verify Cannot Save in Production checkbox is unchecked
    And I verify text "When selected, save is disabled in production" does not exist on User Details page in Rave
    And I take a screenshot
    And I search for subject "sub_name" for study named "study_name" and site "site_name"
    And I navigate to form "Form1" in Rave
    And I take a screenshot
    And I verify text "Saving is disabled. Contact Medidata Customer Care at tollfree.mdsol.com for assistance." is not available of EDC page
    Then I verify Save button is enabled
    Then I verify Sign and Save button is enabled
    And I enter the following data for the "Form1" Rave form:
      | Field Name | Type | Value |
      | First Name | text | FName |
      | Last Name  | text | LName |
    And I save Rave EDC form
    And In Rave I verify the following data on the "Form1" EDC form in Rave:
      | Field Name | Value |
      | First Name | FName |
      | Last Name  | LName |
    And I take a screenshot
    And I logout from "rave"

  @Validation
  @Release2014.2.0
  @PB-111358-03
  Scenario: When "Cannot save in Production" flag in iMedidata is updated then it should also update the flag in corresponding rave user’s account
    Given I login to "rave" as user "defuser"
    And I add a subject for study "study_name" and site "site_name" with following values:
      | Field Name  | Type | Value |
      | Subject ID: | text | 3_<l> |
    And I take a screenshot
    And I logout from "rave"
    Given I login to "imedidata" as user "helpdeskuser"
    And I navigate to Helpdesk in iMedidata
    Given Cannot Save in Production flag for email "cloudadmiral+user_003@gmail.com" is checked in iMedidata
    And I take a screenshot
    And I logout from "imedidata"
    Given I login to "imedidata" as user "user_003"
    And In iMedidata I navigate to "Rave EDC" for study "study_name"
    And I search for user in Rave using the values below:
      | Last Name | Log In   | Site | Site Group | Role | Study      | Authenticator |
      |           | user_003 |      |            |      | study_name | iMedidata     |
    And I go to user details for "user_003"
    Then In Rave I verify Cannot Save in Production checkbox is checked
    And I take a screenshot
    And I logout from "rave"
    Given I login to "imedidata" as user "helpdeskuser"
    And I navigate to Helpdesk in iMedidata
    Given Cannot Save in Production flag for email "cloudadmiral+user_003@gmail.com" is unchecked in iMedidata
    And I take a screenshot
    And I logout from "imedidata"
    Given I login to "imedidata" as user "user_003"
    And In iMedidata I navigate to "Rave EDC" for study "study_name"
    And I navigate to User Administration in Rave
    And I search for user in Rave using the values below:
      | Last Name | Log In   | Site | Site Group | Role | Study      | Authenticator |
      |           | user_003 |      |            |      | study_name | iMedidata     |
    And I go to user details for "user_003"
    Then In Rave I verify Cannot Save in Production checkbox is unchecked
    And I take a screenshot
    And I logout from "rave"

  @Validation
  @Release2014.2.0
  @PB-111358-04
  Scenario: When same user exists in both Rave and iMedidata and rave user has "Cannot Save in Production" checked but iMedidata user does not have Cannot Save in Production checked then upon linking both the accounts, the flag in Rave should get unchecked.
    Given I login to "rave" as user "defuser"
    And I have the following data set:
      | Key            | Value                               |
      | user_004       | user_004<c1>                        |
      | user_004_email | cloudadmiral+user_004<c1>@gmail.com |
    And iMedidata user account is not linked to Rave account with following details:
      | Field                     | Value          |
      | Login                     | user_004       |
      | PIN                       | 12345          |
      | First Name                | user           |
      | Last Name                 | user_004       |
      | Email                     | user_004_email |
      | Trained Date              | 26 Aug 2014    |
      | Training Signed           | true           |
      | Cannot Save in Production | checked        |
    And I take a screenshot
    And I logout from "rave"
    And I login to "imedidata" as user "mistadmin"
    And I search for a study "study_name" and navigate to Manage Study page
    And I invite a user with the values below:
      | Email                               | isOwner | OwnerType | Apps                   | Roles                | SiteName  |
      | cloudadmiral+user_004<c1>@gmail.com | false   |           | Rave EDC, Rave Modules | cdm1qtp, All Modules | All Sites |
    And the user with email "cloudadmiral+user_004<c1>@gmail.com" activates the account using the required values below:
      | Username     | First | Last     | Phone        | Select Timezone                                | Select Locale | Password  | Security Question        | Answer |
      | user_004<c1> | user  | 004_<c1> | 123-456-7890 | (GMT-05:00) - Eastern Time (US & Canada) - EDT | English       | Password1 | What year were you born? | 1970   |
    And I perform actions for invitations in iMedidata using the values below:
      | Name       | Environment | Invitation |
      | study_name | PROD        | Accept     |
    And I logout from "iMedidata"
    And I login to "imedidata" as user "helpdeskuser"
    And I navigate to Helpdesk in iMedidata
    And Cannot Save in Production flag for email "cloudadmiral+user_004<c1>@gmail.com" is unchecked in iMedidata
    And I logout from "imedidata"
    And I login to iMedidata as newly created user "user_004<c1>"
    And In iMedidata I navigate to "Rave EDC" for study "study_name"
    And I link iMedidata user with Rave account "rave_user" and password "password"
    And I search for user in Rave using the values below:
      | Last Name | Log In   | Site | Site Group | Role | Study      | Authenticator |
      |           | user_004 |      |            |      | study_name | iMedidata     |
    When I go to user details for "user_004<c1>"
    Then In Rave I verify Cannot Save in Production checkbox is unchecked
    And I take a screenshot
    And I logout from "rave"

  @Validation
  @Release2014.2.0
  @PB-111358-05
  Scenario: When same user exists in both Rave and iMedidata and rave user has "Cannot Save in Production" unchecked but iMedidata user has “Cannot Save in Production” checked then upon linking both the accounts, the flag in Rave should get checked.
    Given I login to "rave" as user "defuser"
    And I have the following data set:
      | Key            | Value                               |
      | user_005       | user_005<c2>                        |
      | user_005_email | cloudadmiral+user_005<c2>@gmail.com |
    And iMedidata user account is not linked to Rave account with following details:
      | Field                     | Value          |
      | Login                     | user_005       |
      | PIN                       | 12345          |
      | First Name                | user           |
      | Last Name                 | user_005       |
      | Email                     | user_005_email |
      | Trained Date              | 26 Aug 2014    |
      | Training Signed           | true           |
      | Cannot Save in Production | unchecked      |
    And I take a screenshot
    And I logout from "rave"
    And I login to "imedidata" as user "mistadmin"
    And I search for a study "study_name" and navigate to Manage Study page
    And I invite a user with the values below:
      | Email                               | isOwner | OwnerType | Apps                   | Roles                | SiteName  |
      | cloudadmiral+user_005<c2>@gmail.com | false   |           | Rave EDC, Rave Modules | cdm1qtp, All Modules | All Sites |
    And the user with email "cloudadmiral+user_005<c2>@gmail.com" activates the account using the required values below:
      | Username     | First | Last     | Phone        | Select Timezone                                | Select Locale | Password  | Security Question        | Answer |
      | user_005<c2> | user  | 005_<c2> | 123-456-7890 | (GMT-05:00) - Eastern Time (US & Canada) - EDT | English       | Password1 | What year were you born? | 1970   |
    And I perform actions for invitations in iMedidata using the values below:
      | Name       | Environment | Invitation |
      | study_name | PROD        | Accept     |
    And I logout from "imedidata"
    And I login to "imedidata" as user "helpdeskuser"
    And I navigate to Helpdesk in iMedidata
    And Cannot Save in Production flag for email "cloudadmiral+user_005<c2>@gmail.com" is checked in iMedidata
    And I take a screenshot
    And I logout from "imedidata"
    And I login to iMedidata as newly created user "user_005<c2>"
    And In iMedidata I navigate to "Rave EDC" for study "study_name"
    And I link iMedidata user with Rave account "rave_user" and password "password"
    And I search for user in Rave using the values below:
      | Last Name | Log In   | Site | Site Group | Role | Study      | Authenticator |
      |           | user_005 |      |            |      | study_name | iMedidata     |
    When I go to user details for "user_005<c2>"
    Then In Rave I verify Cannot Save in Production checkbox is checked
    And I take a screenshot
    And I logout from "rave"

  @Validation
  @Release2014.2.0
  @PB-111358-06
  Scenario: iMedidata user with "Cannot Save in Production" checked in iMedidata should be able to save data for non production studies in Rave.
    Given I login to "rave" as user "defuser"
    And I add a subject for study "study_dev" and site "site_name" with following values:
      | Field Name  | Type | Value |
      | Subject ID: | text | 6_<l> |
    And I take a screenshot
    And I logout from "rave"
    Given I login to "imedidata" as user "helpdeskuser"
    And I navigate to Helpdesk in iMedidata
    Given Cannot Save in Production flag for email "cloudadmiral+user_006@gmail.com" is checked in iMedidata
    And I logout from "imedidata"
    And I login to "imedidata" as user "user_006"
    And In iMedidata I navigate to "Rave EDC" for study "study_name"
    And I search for user in Rave using the values below:
      | Last Name | Log In   | Site | Site Group | Role | Study      | Authenticator |
      |           | user_006 |      |            |      | study_name | iMedidata     |
    And I go to user details for "user_006"
    Then In Rave I verify Cannot Save in Production checkbox is checked
    And I verify text "When selected, save is disabled in production" exists on User Details page in Rave
    And I take a screenshot
    And I search for subject "sub_name" for study named "study_name" and site "site_name"
    And I navigate to form "Form1" in Rave
    And I verify text "Saving is disabled. Contact Medidata Customer Care at tollfree.mdsol.com for assistance." is not available of EDC page
    Then I verify Save button is enabled
    Then I verify Sign and Save button is enabled
    And I take a screenshot
    And I enter the following data for the "Form1" Rave form:
      | Field Name | Type | Value |
      | First Name | text | FName |
      | Last Name  | text | LName |
    And I save Rave EDC form
    And In Rave I verify the following data on the "Form1" EDC form in Rave:
      | Field Name | Value |
      | First Name | FName |
      | Last Name  | LName |
    And I take a screenshot
    And I logout from "rave"
