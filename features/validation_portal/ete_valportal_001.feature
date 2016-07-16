Feature: Audit Coordinator can make projects visible to Auditors.
  Auditors can view projects assigned to them.
  As a Audit Coordinator user I should be able to navigate through the Validation Portal, Create a Project, Add Versions to it, Upload documents to Versions and Release Versions and Make the Projects externally visible to Auditors.
  As an Auditor user I should be able to navigate through the Validation Portal and view only projects that are externally visible. I should only be able to view Released Versions within these externally visible projects.

  Background:
    Given I have the following data set:
      | Key             | Value                    |
      | envproject_name | ACSmokeTestProjectENV<s> |
      | envproject_id   | ACSmokeTestProjectENV<s> |
      | evproject_name  | ACSmokeTestProjectEV<s>  |
      | evproject_id    | ACSmokeTestProjectEV<s>  |
      | study_group     | valportal-validation     |

  @PB-157689-01
  @Release2015.1.0
  @ValidationPortal
  Scenario: Audit Coordinator user can create a Project that is not visible externally
    Given I login to "iMedidata" as user "valportal-auditcoordinator"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I take a screenshot
    When I create the following Projects in Validation Portal:
      | Display Name    | Identifier    | GitHub Repository | Project Type   | Externally Visible |
      | envproject_name | envproject_id | false             | Product/Module | false              |
    Then I should be on the Validation Portal project detail page
    And I should see the message "Project was successfully created" on the Project Detail page
    And I take a screenshot
    And I logout from Validation Portal
    And I take a screenshot

  @PB-157689-02
  @Release2015.1.0
  @ValidationPortal
  Scenario: Audit Coordinator user can create a Project that is visible externally
    Given I login to "iMedidata" as user "valportal-auditcoordinator"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    When I create the following Projects in Validation Portal:
      | Display Name   | Identifier   | GitHub Repository | Project Type   | Externally Visible |
      | evproject_name | evproject_id | false             | Product/Module | true               |
    Then I should be on the Validation Portal project detail page
    And I should see the message "Project was successfully created" on the Project Detail page
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157689-03
  @Release2015.1.0
  @ValidationPortal
  Scenario: Audit Coordinator user can create a Release Version
    Given I login to "iMedidata" as user "valportal-auditcoordinator"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "evproject_name"
    And I take a screenshot
    And I open project "evproject_name" in Validation Portal
    And I take a screenshot
    When I create the following Version:
      | Version  | Git branch | Release Type |
      | 2014.1.0 | false      | Release      |
    Then I should be on Version Detail page "2014.1.0"
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157689-04
  @Release2015.1.0
  @ValidationPortal
  Scenario: Audit Coordinator user can create a Hotfix Version
    Given I login to "iMedidata" as user "valportal-auditcoordinator"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "evproject_name"
    And I take a screenshot
    And I open project "evproject_name" in Validation Portal
    And I take a screenshot
    When I create the following Version:
      | Version  | Git branch | Release Type |
      | 2014.1.1 | false      | Hotfix       |
    Then I should be on Version Detail page "2014.1.1"
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157689-05
  @Release2015.1.0
  @ValidationPortal
  Scenario: Audit Coordinator user can upload documents to a Version
    Given I login to "iMedidata" as user "valportal-auditcoordinator"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "evproject_name"
    And I open project "evproject_name" in Validation Portal
    And I take a screenshot
    And I select the version "2014.1.0"
    And I take a screenshot
    And I select the following Validation Document Types:
      | Document Type     |
      | Software Overview |
    And I take a screenshot
    When I upload the following file to the Validation Documents page:
      | Document                                   |
      | Rave Test Results.zip                      |
    Then I should see the message "Document was successfully uploaded" on the Validation Documents page
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157689-06
  @Release2015.1.0
  @ValidationPortal
  Scenario: Audit Coordinator user can release a Version
    Given I login to "iMedidata" as user "valportal-auditcoordinator"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "evproject_name"
    And I open project "evproject_name" in Validation Portal
    And I select the version "2014.1.0"
    And I select the following Validation Document Types:
      | Document Type     |
      | Software Overview |
    And I take a screenshot
    When I release the version
    Then I should be on the Validation Portal project detail page
    And I should see the project "evproject_name" with message "2014.1.0 released successfully" on the Project Detail Page
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157689-07
  @Release2015.1.0
  @ValidationPortal
  Scenario: Auditor user can view projects that are externally visible
    Given I login to "iMedidata" as user "valportal-auditor"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I take a screenshot
    When I search for project "evproject_name"
    Then I should see "evproject_name" in the search results
    And I take a screenshot
    And I logout from Validation Portal
    And I take a screenshot

  @PB-157689-08
  @Release2015.1.0
  @ValidationPortal
  Scenario: Auditor user cannot view projects that are not externally visible
    Given I login to "iMedidata" as user "valportal-auditor"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I take a screenshot
    When I search for project "envproject_name"
    Then I should not see "envproject_name" in the search results
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157689-09
  @Release2015.1.0
  @ValidationPortal
  Scenario: Medidata View user can view all projects
    Given I login to "iMedidata" as user "valportal-viewonly"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I take a screenshot
    And I search for project "evproject_name"
    And I should see "evproject_name" in the search results
    And I take a screenshot
    When I search for project "envproject_name"
    Then I should see "envproject_name" in the search results
    And I take a screenshot
    And I logout from Validation Portal
    And I take a screenshot

  @PB-157689-10
  @Release2015.1.0
  @ValidationPortal
  Scenario: Auditor user can only view Released Versions
    Given I login to "iMedidata" as user "valportal-auditor"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I take a screenshot
    And I search for project "evproject_name"
    And I take a screenshot
    When I open project "evproject_name" in Validation Portal
    Then the released versions section should include versions:
      | Versions |
      | 2014.1.0 |
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157689-11
  @Release2015.1.0
  @ValidationPortal
  Scenario: Auditor user cannot view Versions in Development
    Given I login to "iMedidata" as user "valportal-auditor"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I take a screenshot
    And I search for project "evproject_name"
    And I take a screenshot
    When I open project "evproject_name" in Validation Portal
    Then the unreleased versions section should not include versions:
      | Versions |
      | 2014.1.1 |
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157689-12
  @Release2015.1.0
  @ValidationPortal
  Scenario: Medidata View user can view both Released Versions and Versions in Development
    Given I login to "iMedidata" as user "valportal-viewonly"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I take a screenshot
    And I search for project "evproject_name"
    And I take a screenshot
    When I open project "evproject_name" in Validation Portal
    Then the released versions section should include versions:
      | Versions |
      | 2014.1.0 |
    And the unreleased versions section should include versions:
      | Versions |
      | 2014.1.1 |
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157689-13
  @Release2015.1.0
  @ValidationPortal
  Scenario: Audit Coordinator user can change the external visibility of a Project
    Given I login to "iMedidata" as user "valportal-auditcoordinator"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I verify that I am logged into Validation Portal as "valportal-auditcoordinator"
    And I should be on the Validation Portal Home Page
    And I search for project "evproject_name"
    And I open project "evproject_name" in Validation Portal
    And I take a screenshot
    When I edit the Project in Validation Portal with the following values:
      | Externally Visible |
      | false              |
    And I should see the message "Project was successfully updated" on the Project Detail page
    And I take a screenshot
    And I navigate back to iMedidata
    And I take a screenshot
    And I logout from "iMedidata"
    And I login to "iMedidata" as user "valportal-auditor"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I verify that I am logged into Validation Portal as "valportal-auditor"
    And I take a screenshot
    And I search for project "evproject_name"
    Then I should not see "evproject_name" in the search results
    And I take a screenshot
    And I logout from Validation Portal

  @PB-157689-14
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can delete a Project with no Versions
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "envproject_name"
    And I open project "envproject_name" in Validation Portal
    And I take a screenshot
    When I delete the project
    Then I should see the message "Project was successfully deleted" on the Validation Portal Home Page
    And I take a screenshot
    And I logout from Validation Portal
