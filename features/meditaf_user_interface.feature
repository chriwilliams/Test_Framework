Feature: Automation Framework User_Interface module
  In order to test the Functionality of Medidata apps end to end
  I should be able to access the Medidata applications using Automation Framework

#  Background:
#      Given I have a config generated using dicebag template
#      Given I have default browser as "firefox"
#      Given I have the credentials defined in the config to be used in the UI module


  @SC-UI-01
  @Validation
  @Release2014.1.0
  @PBMCC-106124
  Scenario: As an integration test user I should be able login to an app, verify login and log out
    Given I login to "iMedidata" as user "mnohai"
    Then I verify the page "home" of app "iMedidata" is displayed
    And I take a screenshot
    And I logout from "iMedidata"


  @SC-UI-02
  @Validation
  @Release2014.1.0
  @PBMCC-106124
  Scenario: As an integration test user I should be able to take a screenshot of the browser
    Given I login to "iMedidata" as user "mnohai"
    And I verify the page "home" of app "iMedidata" is displayed
    And I take a screenshot
    And I logout from "iMedidata"


  @SC-UI-03
  @Validation
  @Release2014.1.0
  @PBMCC-106124
  Scenario: As an integration test user I should be able to navigate in the app by accessing web elements
    Given I login to "iMedidata" as user "mnohai"
    And I verify the link "eLearning" is seen on page "home"
    And I take a screenshot
    And I click on "eLearning" link
    And I verify that page "eLearning" is displayed
    And I take a screenshot
    And I logout from "iMedidata"


  @SC-UI-04
  @Validation
  @Release2014.1.0
  @PBMCC-106124
  Scenario: As an integration test user I should be able to go to home page from anywhere
    Given I login to "iMedidata" as user "mnohai"
    And I click on "Studies" link
    And I verify that page "Studies" is displayed
    And I go back to Homepage
    And I verify that page "Home" is displayed
    And I logout from "iMedidata"