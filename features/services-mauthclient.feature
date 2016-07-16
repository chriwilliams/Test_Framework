Feature: Automation Framework Services module for MAuth Client
  In order to test the Functionality of Medidata apps end to end
  I should be able to access the api and resources of Medidata Services using Automation framework


  Background:
  #      Given I have a Mauth config generated using dicebag template
  #      Given I have the credentials defined in the config to be used in the Services module
  #      An client app is registered and the appid defined in the config


  @PB-MCC-106020
  @SC-services-mauth-01
  @Validation
  @Release2014.1.0
  Scenario: As an integration test user I should be able to list studies in a studygroup in imedidata
    Given I can make a request to imedidata to list all the studies for the study group
    When I send the request with a StudyGroupId of "66d005f9-c0a6-434c-ad8d-787dddd32cc5"
    Then I should get a "200" status result


  @PB-MCC-106020
  @SC-services-mauth-02
  @Validation
  @Release2014.1.0
  Scenario: As an integration test user I should be able to create study in a studygroup in imedidata
    Given I can make a request to imedidata to create a study
    When I send the request with following attributes:
      | StudyGroupUUID                       | name    | oid         | protocol         |
      | 66d005f9-c0a6-434c-ad8d-787dddd32cc5 | MStudy1 | MStudy1_OID | MStudy1_Protocol |
    Then I should get a "201" status result
    And I store "study" response value "uuid" in "StudyUUID"
    And I store "study" response value "name" in "StudyName"
    And I store "study" response value "oid" in "StudyOID"
    And I store "study" response value "protocol" in "StudyProtocol"


  @PB-MCC-106020
  @SC-services-mauth-03
  @Validation
  @Release2014.1.0
  Scenario: As an integration test user I should be able to update a study in a studygroup in imedidata
    Given I can make a request to imedidata to update the created study
    When I send the request with following attributes:
      | name       | protocol      |
      | New_Study1 | New_Protocol1 |
    Then I should get a "200" status result
