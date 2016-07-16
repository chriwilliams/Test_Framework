Feature: Integration of Applications Rave and iMedidata

  @selenium
  @smoketest
  Scenario: Smoke Test UI scenario

    Given I login to "iMedidata" as user "mistadmin"
    Then I verify the page "home" of app "iMedidata" is displayed
    And I take a screenshot
    And I logout from "iMedidata"

  @headless
  @smoketest
  Scenario: MIST Env and Helpers test
    * I verify global variables initialized in env
    * I verify randomize_arg method with options

#  @SC-services-01
#  @Validation
#  @Release2014.1.0
#  @PBMCC-106128
#
#  Scenario: As an integration test user I should be able to CREATE a resource
#    Given I list the courses in imedidata
#    And then I assign the course with following values:
#        | CourseUUID  | Study      | user |
#        | courseuuid | MCC Study  |  Useruuid |
