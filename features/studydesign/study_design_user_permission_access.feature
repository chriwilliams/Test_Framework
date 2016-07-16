Feature: User Permission Access - Landing page - Security testing

  @Release.2015.3.0
  @PB161003-01
  @security
  @smoketest
  @studydesign
  @selenium
  Scenario: Users assigned at the Client Division Level are able to view all studies belonging to Client Division
    Given I login to "iMedidata" as user "meditaf_09"
    When I navigate to "Design Optimization" for study group "SD_MultiStudy" using the "Study Group Launcher" in iMedidata
    And I verify the page "All_Studies" of app "Study_Design" is displayed
    And the number of "Studies" is 5 within Design Optimization "All Studies" page
    Then I can see the following studies within Design Optimization "All Studies" page:
      | Protocol ID             | Study Name                          |
      | Multi Indication Study  | Multi Study Multi Indication Study  |
      | Read Edit Scenario      | Multi Study Read Edit               |
      | Read Export Study       | Multi Study Read Export             |
      | Read Only Study         | Multi Study Read Only               |
      | Single Indication Study | Multi Study Single Indication Study |
    And I take a screenshot
    And I logout from "iMedidata"
    When I login to "iMedidata" as user "meditaf_13"
    And I navigate to "Design Optimization" for study group "SD_MultiStudy" using the "Study Group Launcher" in iMedidata
    And I verify the page "All_Studies" of app "Study_Design" is displayed
    And the number of "Studies" is 5 within Design Optimization "All Studies" page
    Then I can see the following studies within Design Optimization "All Studies" page:
      | Protocol ID             | Study Name                          |
      | Multi Indication Study  | Multi Study Multi Indication Study  |
      | Read Edit Scenario      | Multi Study Read Edit               |
      | Read Export Study       | Multi Study Read Export             |
      | Read Only Study         | Multi Study Read Only               |
      | Single Indication Study | Multi Study Single Indication Study |
    And I take a screenshot
    And I logout from "iMedidata"

  @Release.2015.3.0
  @PB161003-02
  @security
  @smoketest
  @studydesign
  @selenium
  Scenario: Users assigned at the Study Level are able to view only assigned studies belonging to Client Division
    Given I login to "iMedidata" as user "meditaf_09"
    When I navigate to "Design Optimization" for study group "SD_MultiStudy" using the "Study Group Launcher" in iMedidata
    And I verify the page "All_Studies" of app "Study_Design" is displayed
    And the number of "Studies" is 5 within Design Optimization "All Studies" page
    Then I can see the following studies within Design Optimization "All Studies" page:
      | Protocol ID             | Study Name                          |
      | Multi Indication Study  | Multi Study Multi Indication Study  |
      | Read Edit Scenario      | Multi Study Read Edit               |
      | Read Export Study       | Multi Study Read Export             |
      | Read Only Study         | Multi Study Read Only               |
      | Single Indication Study | Multi Study Single Indication Study |
    And I take a screenshot
    And I logout from "iMedidata"
    When I login to "iMedidata" as user "meditaf_10"
    And I navigate to "Design Optimization" for study group "SD_MultiStudy" using the "Study Group Launcher" in iMedidata
    And I verify the page "All_Studies" of app "Study_Design" is displayed
    And the number of "Studies" is 1 within Design Optimization "All Studies" page
    Then I can see the following studies within Design Optimization "All Studies" page:
      | Protocol ID             | Study Name                          |
      | Read Only Study         | Multi Study Read Only               |
    And I take a screenshot
    And I logout from "iMedidata"
    When I login to "iMedidata" as user "meditaf_11"
    And I navigate to "Design Optimization" for study group "SD_MultiStudy" using the "Study Group Launcher" in iMedidata
    And I verify the page "All_Studies" of app "Study_Design" is displayed
    And the number of "Studies" is 1 within Design Optimization "All Studies" page
    Then I can see the following studies within Design Optimization "All Studies" page:
      | Protocol ID             | Study Name                          |
      | Read Export Study       | Multi Study Read Export             |
    And I take a screenshot
    And I logout from "iMedidata"
    When I login to "iMedidata" as user "meditaf_12"
    And I navigate to "Design Optimization" for study group "SD_MultiStudy" using the "Study Group Launcher" in iMedidata
    And I verify the page "All_Studies" of app "Study_Design" is displayed
    And the number of "Studies" is 2 within Design Optimization "All Studies" page
    Then I can see the following studies within Design Optimization "All Studies" page:
      | Protocol ID             | Study Name                          |
      | Multi Indication Study  | Multi Study Multi Indication Study  |
      | Read Edit Scenario      | Multi Study Read Edit               |
    And I take a screenshot
    And I logout from "iMedidata"

  @Release.2015.3.0
  @PB161003-03
  @security
  @smoketest
  @studydesign
  @selenium
  Scenario: User with authorizations at the Client Division but with No access permissions to scenarios get an error when attempt to load a Design Optimization study page
    Given I login to "iMedidata" as user "meditaf_13"
    When I navigate to "Design Optimization" for study group "SD_MultiStudy" using the "Study Group Launcher" in iMedidata
    And I verify the page "All_Studies" of app "Study_Design" is displayed
    Then I can see the following studies within Design Optimization "All Studies" page:
      | Protocol ID             | Study Name                          |
      | Multi Indication Study  | Multi Study Multi Indication Study  |
      | Read Edit Scenario      | Multi Study Read Edit               |
      | Read Export Study       | Multi Study Read Export             |
      | Read Only Study         | Multi Study Read Only               |
      | Single Indication Study | Multi Study Single Indication Study |
    When I select the study "Multi Study Multi Indication Study" within Design Optimization landing page
    And I take a screenshot
    And I logout from "iMedidata"

  @Release.2015.3.0
  @PB161003-04
  @security
  @smoketest
  @studydesign
  @selenium
  Scenario: User with Read-Only Access to study scenario should not be able to create a new scenario
    Given I login to "iMedidata" as user "meditaf_10"
    When I navigate to "Design Optimization" for study group "SD_MultiStudy" using the "Study Group Launcher" in iMedidata
    And I verify the page "All_Studies" of app "Study_Design" is displayed
    Then I can see the following studies within Design Optimization "All Studies" page:
      | Protocol ID             | Study Name                          |
      | Read Only Study         | Multi Study Read Only               |
    When I select the study "Multi Study Read Only" within Design Optimization landing page
    Then I verify the page "home" of app "Study_Design" is displayed
    And I verify the Page title is "Design Optimization" and the Study title is "Multi Study Read Only"
    And I verify "Home" page for the Design Optimization study is "Read Only"
    And I take a screenshot
    And I logout from "iMedidata"

  @Release.2015.3.0
  @PB161003-05
  @security
  @smoketest
  @studydesign
  @selenium
  Scenario: User with Read-Export Access to study scenario should not be able to create a new scenario
    Given I login to "iMedidata" as user "meditaf_11"
    When I navigate to "Design Optimization" for study group "SD_MultiStudy" using the "Study Group Launcher" in iMedidata
    And I verify the page "All_Studies" of app "Study_Design" is displayed
    Then I can see the following studies within Design Optimization "All Studies" page:
      | Protocol ID             | Study Name                          |
      | Read Export Study       | Multi Study Read Export             |
    When I select the study "Multi Study Read Export" within Design Optimization landing page
    Then I verify the page "home" of app "Study_Design" is displayed
    And I verify the Page title is "Design Optimization" and the Study title is "Multi Study Read Export"
    And I verify "Home" page for the Design Optimization study is "Read Only"
    And I take a screenshot
    And I logout from "iMedidata"

  @Release.2015.3.0
  @PB161003-06
  @security
  @smoketest
  @studydesign
  @selenium
  Scenario: User with Read-Edit Access to study scenario should be able to create a new scenario
    Given I login to "iMedidata" as user "meditaf_12"
    When I navigate to "Design Optimization" for study group "SD_MultiStudy" using the "Study Group Launcher" in iMedidata
    And I verify the page "All_Studies" of app "Study_Design" is displayed
    Then I can see the following studies within Design Optimization "All Studies" page:
      | Protocol ID             | Study Name                          |
      | Multi Indication Study  | Multi Study Multi Indication Study  |
      | Read Edit Scenario      | Multi Study Read Edit               |
    When I select the study "Multi Study Read Edit" within Design Optimization landing page
    And I verify the page "home" of app "Study_Design" is displayed
    And I verify the Page title is "Design Optimization" and the Study title is "Multi Study Read Edit"
    Then I create a new scenario
    And I take a screenshot
    And I logout from "iMedidata"
