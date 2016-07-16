Feature: Smoke Testing the Validation Portal

  As a Superadmin user I should be able to navigate through the Validation Portal, Create a Project, Add Versions to a Project and Release Versions.
  I should also be able to Unrelease Released Versions, Edit and Delete Versions in Development and Delete Projects with no Versions.

  As an Audit Coordinator user I should be able to Make the Projects externally visible to Auditors.

  @smoketest
  @PB-167884-01
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can create a Project
    Given I have the following data set:
      | Key          | Value               |
      | project_name | SmokeTestProject<s> |
      | project_id   | SmokeTestProject<s> |
      | study_group  | Valportal-Sandbox   |
    And I login to "iMedidata" as user "valportal-superadmin"
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

  @smoketest
  @PB-167884-02
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

  @smoketest
  @PB-167884-03
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
      | Document                                   |
      | Medidata CTMS 2013.1.1 Validation Plan.pdf |
    Then I should see the message "Document was successfully uploaded" on the Validation Documents page
    And I take a screenshot
    And I logout from Validation Portal

  @smoketest
  @PB-167884-04
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can release a Version
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "project_name"
    And I open project "project_name" in Validation Portal
    And I select the version "2014.1.0"
    And I select the following Validation Document Types:
      | Document Type     |
      | Software Overview |
    And I take a screenshot
    When I release the version
    Then I should be on the Validation Portal project detail page
    And I should see the project "project_name" with message "2014.1.0 released successfully" on the Project Detail Page
    And I take a screenshot
    And I logout from Validation Portal

  @smoketest
  @PB-167884-05
  @Release2015.1.0
  @ValidationPortal
  Scenario: Audit Coordinator user can change the external visibility of a Project
    Given I login to "iMedidata" as user "valportal-auditcoordinator"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I verify that I am logged into Validation Portal as "valportal-auditcoordinator"
    And I should be on the Validation Portal Home Page
    And I search for project "project_name"
    And I open project "project_name" in Validation Portal
    And I take a screenshot
    When I edit the Project in Validation Portal with the following values:
      | Externally Visible |
      | true               |
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
    And I search for project "project_name"
    Then I should see "project_name" in the search results
    And I take a screenshot
    And I logout from Validation Portal

  @smoketest
  @PB-167884-06
  @Release2015.1.0
  @ValidationPortal
  Scenario: Superadmin user can unrelease a Released Version
    Given I login to "iMedidata" as user "valportal-superadmin"
    And In iMedidata I navigate to "ValidationPortal" for study group "study_group"
    And I should be on the Validation Portal Home Page
    And I search for project "project_name"
    And I open project "project_name" in Validation Portal
    And I select the version "2014.1.0"
    And I select the following Validation Document Types:
      | Document Type     |
      | Software Overview |
    And I take a screenshot
    And I visit the Administrator Options page for the selected version
    And I take a screenshot
    When I unrelease the Released Version
    Then I should be on Version Detail page "2014.1.0"
    And I take a screenshot
    And I logout from Validation Portal

  @smoketest
  @PB-167884-07
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

  @smoketest
  @PB-167884-08
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

  @smoketest
  @PB-167884-09
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
