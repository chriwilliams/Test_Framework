Feature: iMedidata End to End - User Upload.

  This end to end scenario verifies that user upload functionality works as expected. Also it verified that user role is properly updated and displayed on study users manage page.

  @Release2014.2.0
  @PB66980-001
  @Draft
  @selenium
  @iMedidata
  Scenario: iMedidata End to End - User Upload.

    Given I login to "iMedidata" as user "siteuser9"
    And I clear all the notifications
    And I navigate to iMedidata Manage Study Group page for "iMedidata End to End SG1" and create study using the values below:
      | Protocol ID        | Study Name           | Environment |
      | iMedidata_PID_<r2> | iMedidata Study <c1> | DEV         |
    And I take a screenshot
    And I select eLearning tab for study "iMedidata Study <c1>" in Manage Study page
    And I take a screenshot
    And I map the course using the values below:
      | Course           | Apps     | Roles        | Required |
      | My Course - MKS  | Rave EDC | Batch Upload | true     |
    And I take a screenshot
    And I select Users tab for study "iMedidata Study <c1>" in Manage Study page
    And I take a screenshot
    And I have a imedidata user csv spreadsheet named "imd_users.csv" with values below:
      | Operation (UPDATE or DELETE)  | update                     | update                     |
      | Email                         | siteuser9@gmail.com        | siteuser9+<c2>@gmail.com   |
      | Study                         | iMedidata Study <c1> (DEV) | iMedidata Study <c1> (DEV) |
      | Rave EDC                      | Batch Upload \| Coder      | Investigator               |
      | Login                         | siteuser9                  | siteuser9+<c2>             |
      | First Name                    | Erin                       | Jane                       |
      | Last Name                     | Adamson                    | Adamson                    |
    And I search for the invited user "siteuser9" on iMedidata Manage Study Page
    And I take a screenshot
    And I override a course for the user "siteuser9"
      | Course          | Reason         |
      | My Course - MKS | Testing course |
    And I take a screenshot
    And I upload users from csv file "imd_users.csv" in the study users manage page
    And I take a screenshot
    And I verify the notification message "The iMedidata Loader has completed processing imd_users.csv with no errors"
    And I search for the invited user "siteuser9" on iMedidata Manage Study Page
    And I verify the user roles assignment and status using the table below:
      | Login           | Apps and Roles                   | Status             |
      | siteuser9       | Rave EDC, Batch Upload and Coder | Access Granted     |
      | siteuser9+<c2>  | Rave EDC, Investigator           | Activation Pending |
    And I take a screenshot
    And I logout from "iMedidata"
    And I take a screenshot
