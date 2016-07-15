Feature: Automation Framework Utils module
  In order to test the Functionality of Medidata apps end to end
  I should be able to use the Utils Module


  @SC-Utils-01
  @Validation
  @Release2014.1.0
  @PBMCC-106143
  Scenario: As an integration test user I should be able to generate Medidata_dateformat as my test data
    Given I generate Medidata_dateformat and print log
    And I should be able to append Medidata_dateformat to string "date-" and print log


  @SC-Utils-02
  @Validation
  @Release2014.1.0
  @PBMCC-106143
  Scenario: As an integration test user I should be able to generate Random number as my test data
    Given I generate Random_number and I print log
    And I should be able append random number to "Study_" and print log

  @SC-Utils-03
  @Validation
  @Release2014.1.0
  @PBMCC-106143
  Scenario: As an integration test user I should be able to generate Timestamps as my test data
    Given I generate "timestamp_short" and I print log
    And I append timestamp_short to "time_short_" and print log
    Then I generate "timestamp_long" and I print log
    And I append timestamp_long to "time_long_" and print log


  @SC-Utils-04
  @Validation
  @Release2014.1.0
  @PBMCC-106143
  Scenario: As an integration test user I should be able to generate UID as my test data
    Given I generate UID and I print log
    And I append UID to "UID_" and print log

  @SC-Utils-05
  @Validation
  @Release2014.1.0
  @PBMCC-106143
  Scenario: As an integration test user I should be able to generate fake address as my test data
    Given I generate address "city" and I print log
    Then I generate address "street_name" and I print log
    And I generate address "street_address" and I print log
    And I generate address "zip_code" and I print log

  @SC-Utils-06
  @Validation
  @Release2014.1.0
  @PBMCC-106143
  Scenario: As an integration test user I should be able to generate fake numbers as my test data
    Given I generate name "first_name" and I print log
    Given I generate name "last_name" and I print log

  @SC-Utils-07
  @Validation
  @Release2014.1.0
  @PBMCC-106143
  Scenario: As an integration test user I should be able to generate phone numbers as my test data
    Given I generate phone_number "cell_phone" and I print log
    Given I generate phone_number "phone_number" and I print log

  @SC-Utils-08
  @Validation
  @Release2014.1.0
  @PBMCC-106143
  Scenario: As an integration test user I should be able to store a value in a variable using sticky
    Given I store value "Medidata" in "Company"
    Given I get value of "Company" and print to log

  @SC-Utils-09
  @Validation
  @Release2014.1.0
  @PBMCC-106143
  Scenario: As an integration test user I should be store the value generated from faker in a variable using sticky
    Given I generate name "first_name" and store value in "UserName" and print log
    And I append "timestamp_short" to "UserName" and print log

  @SC-Utils-10
  @Validation
  @Release2015.1.0
  @PBMCC-106143
  Scenario: As an integration test user I should be able to parse invitation email in user inbox
    Given Invitation email is delivered to user inbox
    When I find latest unread email from specified sender in user inbox
    Then It should contain invitation url

  @SC-Utils-11
  @Validation
  @Release2016.1.0
  @PBMCC-201777
  Scenario: As an integration test user I should be able to parse invitation email in inbox of specific user
    Given An invitation email is delivered to the inbox of the following users:
      | User | Email                |
      | 1    | jenkins_ci@mdsol.com |
    When I find latest unread email from specified sender in the inbox of a specific user at position 1 in the email thread
    Then It should contain invitation url

  @SC-Utils-12
  @Validation
  @Release2016.1.0
  @PBMCC-201777
  Scenario: As an integration test user I should be able to parse invitation email in inbox of specific user from a chain of emails
    Given An invitation email is delivered to the inbox of the following users:
      | User | Email                |
      | 1    | jenkins_ci@mdsol.com |
      | 2    | jenkins_ci@mdsol.com |
      | 3    | jenkins_ci@mdsol.com |
      | 4    | jenkins_ci@mdsol.com |
    When I find latest unread email from specified sender in the inbox of a specific user at position 2 in the email thread
    Then It should contain invitation url