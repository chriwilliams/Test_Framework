Feature: I am able to navigate through the iMedidata site, and perform authorized activities with respect to Study Design Optimization.
  - I can login to imedidata
  - I can access Client Divisions directly or through search and pagination
  - I can access an existing studies through search, pagination or within a Client Division
  - I can logout from iMedidada and Study Design Optimization



  @PB113940-01
  @smoketest
  @studydesign
  @selenium
  Scenario: I access a Design Optimization study via direct search of Study title in MCC Admin
    Given I login to "iMedidata" as user "meditaf_09"
    And In iMedidata I navigate to "MCCAdmin" for study "Zero Scenario Study"
    And I navigate to "Design Optimization" page from "Manage Users" page
    Then I verify the page "home" of app "Study_Design" is displayed
    And I verify the Page title is "Design Optimization" and the Study title is "Zero Scenario Study"
    And I logout from "iMedidata"

  @PB113940-02
  @smoketest
  @studydesign
  @selenium
  Scenario: I access a Design Optimization study via direct search of Study title and App Launcher in MCC Admin
    Given I login to "iMedidata" as user "meditaf_09"
    And I search for study "Zero Scenario Study"
    When I navigate to "Design Optimization" for study "Zero Scenario Study" using the "App Launcher" in iMedidata
    Then I verify the page "home" of app "Study_Design" is displayed
    And I verify the Page title is "Design Optimization" and the Study title is "Zero Scenario Study"
    And I logout from "iMedidata"

  @PB113940-03
  @smoketest
  @studydesign
  @selenium
  Scenario: I access a Design Optimization study via Pagination in MCC Admin
    Given I login to "iMedidata" as user "meditaf_09"
    When I navigate to "Design Optimization" for study "Zero Scenario Study" using the "Study Launcher" in iMedidata
    And I navigate to "Design Optimization" page from "Manage Users" page
    Then I verify the page "home" of app "Study_Design" is displayed
    And I verify I am on the "No Scenario" page of the "Study Design" app with study "Zero Scenario Study"
    And I logout from "iMedidata"

  @PB113940-04
  @smoketest
  @studydesign
  @selenium
  Scenario: I access a Design Optimization study via the App Launcher with Pagination in MCC Admin
    Given I login to "iMedidata" as user "meditaf_09"
    When I navigate to "Design Optimization" for study "Zero Scenario Study" using the "App Launcher" in iMedidata
    Then I verify the page "home" of app "Study_Design" is displayed
    And I verify I am on the "No Scenario" page of the "Study Design" app with study "Zero Scenario Study"
    And I logout from "iMedidata"

  @PB113940-05
  @smoketest
  @studydesign
  @selenium
  Scenario: I access a Design Optimization study via consecutive search of Client Division and Study title in MCC Admin
    Given I login to "iMedidata" as user "meditaf_09"
    And In iMedidata I navigate to "MCCAdmin" for study group "SD_MIST104"
    And I navigate to "Zero Scenario Study" Study in "Study Design" study list
    And I navigate to "Design Optimization" page from "Manage Users" page
    Then I verify the page "home" of app "Study_Design" is displayed
    And I verify the Page title is "Design Optimization" and the Study title is "Zero Scenario Study"
    And I logout from "iMedidata"

  @PB113940-06
  @smoketest
  @studydesign
  @selenium
  Scenario: I access a Design Optimization study via consecutive search of Client Division and Study title with App Launcher
    Given I login to "iMedidata" as user "meditaf_09"
    And I search for study group "SD_MIST104"
    When I navigate to "Design Optimization" for study group "SD_MIST104" using the "App Launcher" in iMedidata
    And I select the study "Zero Scenario Study" within Design Optimization landing page
    Then I verify the page "home" of app "Study_Design" is displayed
    And I verify the Page title is "Design Optimization" and the Study title is "Zero Scenario Study"
    And I logout from "iMedidata"

  @PB113940-07
  @smoketest
  @studydesign
  @selenium
  Scenario: I access a Design Optimization study from the All Studies page through Client Division from left pane menu
    Given I login to "iMedidata" as user "meditaf_09"
    When I navigate to "Design Optimization" for study group "SD_MIST104" using the "Study Group Launcher" in iMedidata
    And I verify the page "All_Studies" of app "Study_Design" is displayed
    When I select the study "Zero Scenario Study" within Design Optimization landing page
    Then I verify the page "home" of app "Study_Design" is displayed
    And I verify the Page title is "Design Optimization" and the Study title is "Zero Scenario Study"
    And I logout from "iMedidata"

  @PB113940-08
  @smoketest
  @studydesign
  @selenium
  Scenario: Once I select a Client Division under the "Apps" menu in iMedidata, I should see the landing page for "All Studies"
    Given I login to "iMedidata" as user "meditaf_09"
    And I verify the following Apps name for iMedidata Apps type:
      | apps                |
      | DESIGN OPTIMIZATION |
    When I navigate to "Design Optimization" for study group "SD_MIST104" using the "Study Group Launcher" in iMedidata
    Then I verify the page "All_Studies" of app "Study_Design" is displayed
    And I can see the "Data" panel within the "All Studies" page
    And I can see the following headers within the "All Studies" page:
      | header               |
      | Protocol ID          |
      | Study Name           |
      | Primary Indication   |
      | Secondary Indication |
      | Phase                |
    And I logout from "iMedidata"

  @PB113940-09
  @smoketest
  @studydesign
  @selenium
  @WIP
  Scenario: I select a study from a client Division via direct navigation to the study, and I switch locale to japanese
    Given I login to "iMedidata" as user "meditaf_09"
    And In iMedidata I navigate to "MCCAdmin" for study group "SD_MIST104"
    And I navigate to "Zero Scenario Study" Study in "Study Design" study list
    And I navigate to "Design Optimization" page from "Manage Users" page
    And I change locale to "Japanese"
    Then I verify the page "home" of app "Study_Design" is displayed
    And I verify the Page title is "デザイン最適化" and the Study title is "Zero Scenario Study"
    And I see the text: "ようこそ" in the "Welcome Message" label within the "No Scenario" page
    And I see the text: "デザイン開始" in the "Start Design" label within the "No Scenario" page
    And I logout from "iMedidata"

  @PB113940-10
  @smoketest
  @studydesign
  @export
  @selenium
  @WIP
  Scenario: Once I access a new study, and I create a new scenario. I should be able to export the scenario.
    Given I login to "iMedidata" as user "meditaf_09"
    And In iMedidata I navigate to "MCCAdmin" for study group "SD_MIST104"
    And I navigate to "Single Indication Study" Study in "Study Design" study list
    And I navigate to "Design Optimization" page from "Manage Users" page
    When I create a new scenario
    And I export the contents from the "Active Scenario" tab
    Then I should get a download for the active scenario in "Single Indication Study" study
    And I logout from "iMedidata"
