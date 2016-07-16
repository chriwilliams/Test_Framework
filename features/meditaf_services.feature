Feature: Automation Framework Services module
  In order to test the Functionality of Medidata apps end to end
  I should be able to access the api and resources of Medidata Services using Automation framework

 # Background:
 #      Given I have a config generated using dicebag template
 #      Given I have the credentials defined in the config to be used in the Services module
 #      An client app is registered


  @SC-services-01
  @Validation
  @Release2014.1.0
  @PBMCC-106128
  @Headless
  Scenario: As an integration test user I should be able to CREATE a resource
    Given I create a resource "Medidations" with following attributes:
      | first_name | Jey   |
      | last_name  | Smith |
    Then I should get a "201" status result


  @SC-services-02
  @Validation
  @Release2014.1.0
  @PBMCC-106128
  @Headless
  Scenario: As an integration test user I should be able to SEARCH a resource
    Given I create a resource "Medidations" with following attributes:
      | first_name | Joe   |
      | last_name  | Smith |
    Then I should get a "201" status result
    And I notedown value of "uuid" from response in "resp_uuid"
    Given I search resource "medidations" using "resp_uuid"
    Then I should get a "200" status result
    And the result should have the attributes and values:
      | uuid            | resp_uuid |
      | first_name      | Joe       |
      | last_name       | Smith     |
      | indication_uuid | nil       |
      | status          | nil       |

  @SC-services-03
  @Validation
  @Release2014.1.0
  @PBMCC-106128
  @Headless
  Scenario: As an integration test user I should be able to UPDATE a resource
    Given I create a resource "Medidations" with following attributes:
      | first_name | Andy  |
      | last_name  | Smith |
    Then I should get a "201" status result
    When I notedown value of "uuid" from response in "resp_uuid"
    When I search resource "medidations" using "resp_uuid"
    Then I should get a "200" status result
    Then I update the resource "medidations" with uuid "resp_uuid" with following attributes and values:
      | first_name     | Joel                                 |
      | last_name      | Bauer                                |
      | job_title_uuid | 1119b500-5fa6-11e2-bcfd-0800200c9111 |
    And I should get a "204" status result


  @SC-services-04
  @Validation
  @Release2014.1.0
  @PBMCC-106128
  @Headless
  Scenario: As an integration test user when I tried to access a resource which is not available I should get an error
    Given I create a resource "aliens" with following attributes:
      | first_name | Will  |
      | last_name  | Smith |
    Then I should get an error
