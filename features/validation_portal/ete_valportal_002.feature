Feature: Super Admin navigates through the Validation Portal

  As a superadmin user I should be able to navigate through the Validation Portal, Create a Project, Add Versions to it, Upload documents to Versions and Release Versions.
  I should also be able to Unrelease Released Versions, Edit Versions in Development, Remove or Replace Uploaded documents, Delete Versions in Development, Edit Projects and Delete Projects with no Versions.

  Background:
    Given I have the following data set:
      | Key          | Value                 |
      | project_name | SASmokeTestProject<s> |
      | project_id   | SASmokeTestProject<s> |
      | study_group  | valportal-validation  |

  @PB-157257-01
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can create a Project
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I take a screenshot
    When I create the following Projects in Validation Portal:
      | Display Name | Identifier | GitHub Repository | Project Type   | Externally Visible |
      | project_name | project_id | false             | Product/Module | false              |
    Then I should be on the Validation Portal project detail page
    And I should see the message "Project was successfully created" on the Project Detail page
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157257-02
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can mark a Project as a Favorite
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I take a screenshot
    And I search for project "project_name"
    And I take a screenshot
    And I open project "project_name" in Validation Portal
    When I mark the project as a favorite
    Then I should see the project "project_name" with message "now marked as favorite" on the Project Detail Page
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157257-03
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can create a Release Version
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "project_name"
    And I take a screenshot
    And I open project "project_name" in Validation Portal
    And I take a screenshot
    When I create the following Version:
      | Version  | Git branch | Release Type |
      | 2014.1.0 | false      | Release      |
    Then I should be on Version Detail page "2014.1.0"
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157257-04
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can upload documents to a Version
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "project_name"
    And I open project "project_name" in Validation Portal
    And I select the version "2014.1.0"
    And I take a screenshot
    And I select the following Validation Document Types:
      | Document Type     |
      | Software Overview |
    And I take a screenshot
    When I upload the following file to the Validation Documents page:
      | Document                            |
      | MCC-55383_prefix_documentation.docx |
    Then I should see the message "Document was successfully uploaded" on the Validation Documents page
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157257-05
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can release a Version
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "project_name"
    And I open project "project_name" in Validation Portal
    And I select the version "2014.1.0"
    And I take a screenshot
    When I release the version
    Then I should be on the Validation Portal project detail page
    And I should see the project "project_name" with message "2014.1.0 released successfully" on the Project Detail Page
    And I take a screenshot
    And I logout from Validation Portal
    
  @PB-157257-06
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can add a Note to File document to a Released Version
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "project_name"
    And I open project "project_name" in Validation Portal
    And I select the version "2014.1.0"
    And I take a screenshot
    When I add the following Note to File:
      | Document                            |
      | MCC-55383_prefix_documentation.docx |
    Then I should see the message "Note to file\Deviation was successfully uploaded"
    And the section "Notes to File\Deviations" exists on the left sidebar
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157257-07
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can unrelease a Released Version
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "project_name"
    And I open project "project_name" in Validation Portal
    And I select the version "2014.1.0"
    And I take a screenshot
    And I visit the Administrator Options page for the selected version
    And I take a screenshot
    When I unrelease the Released Version
    Then I should be on Version Detail page "2014.1.0"
    And the section "Notes to File\Deviations" exists on the left sidebar
    And I select the following Validation Document Types:
      | Document Type            |
      | Notes to File\Deviations |
    And I verify the following documents appear:
      | Documents                           |
      | MCC-55383_prefix_documentation.docx |
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157257-08
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can edit a Version
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "project_name"
    And I open project "project_name" in Validation Portal
    And I select the version "2014.1.0"
    And I take a screenshot
    When I edit the Version in Validation Portal with the following values:
      | Version  |
      | 2014.2.0 |
    Then I should see the message "Version was successfully updated"
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157257-09
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can replace an uploaded document within a Version
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "project_name"
    And I open project "project_name" in Validation Portal
    And I select the version "2014.2.0"
    And I select the following Validation Document Types:
      | Document Type     |
      | Software Overview |
    And I take a screenshot
    When I replace the uploaded document using Document Actions Menu with following document:
      | Document                            |
      | Medidata CTMS Software Overview.pdf |
    Then I should see the message "Document was successfully uploaded"
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157257-10
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can remove an uploaded document within a Version
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "project_name"
    And I open project "project_name" in Validation Portal
    And I select the version "2014.2.0"
    And I select the following Validation Document Types:
      | Document Type     |
      | Software Overview |
    And I take a screenshot
    When I remove the uploaded document using Document Actions Menu
    Then I should see the message "Document was successfully removed"
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157257-11
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user cannot delete a Project with Versions
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "project_name"
    And I open project "project_name" in Validation Portal
    And I take a screenshot
    When I delete the project
    Then I should see the message "Project was not deleted. Please remove all versions from the project before deleting it" on the Validation Portal Home Page
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157257-12
  @Release2015.1.0
  @ValidationPortal
  Scenario: Medidata Edit user cannot delete a Version with uploaded documents
    Given I login to "iMedidata" as user "valportal-edit"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "project_name"
    And I open project "project_name" in Validation Portal
    And I select the version "2014.2.0"
    And I take a screenshot
    When I delete the Version "2014.2.0"
    Then I should see the message "Version was not deleted. Please remove all the Validation Documents before deleting the version" on the Validation Documents page
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157257-13
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can delete a Version
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "project_name"
    And I open project "project_name" in Validation Portal
    And I select the version "2014.2.0"
    And I take a screenshot
    When I delete the Version "2014.2.0"
    Then I should see the message "Version was successfully removed"
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157257-14
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can edit a Project
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "project_name"
    And I open project "project_name" in Validation Portal
    And I take a screenshot
    When I edit the Project in Validation Portal with the following values:
      | Externally Visible |
      | true               |
    Then I should see the message "Project was successfully updated"
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157257-15
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can delete a Project with no Versions
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "project_name"
    And I open project "project_name" in Validation Portal
    And I take a screenshot
    When I delete the project
    Then I should see the message "Project was successfully deleted" on the Validation Portal Home Page
    And the Project "project_name" should not be in the favorites panel
    And I take a screenshot
    And I logout from Validation Portal
