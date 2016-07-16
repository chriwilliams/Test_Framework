Feature: I am able to utilize real services in Janus for Apollo and Athena

  Background:
    Given I am impersonating user "janusIntegrationTester1"
    And I should have study "JanusIntegrationTestStudy4" in the client division

  @janus_service
  Scenario: As an integration test user, I should be able to create: design scenario, objectives, endpoints, schedule, StudyActivity, StudyEvent, StudyCell
    And I create design scenario "service_e2e"
    Then I should have a design scenario "service_e2e"
    And I create an objective "objective 1" of type "primary"
    Then I should have an objective
    When I create endpoints:
      | endpoint   | endpoint type | endpoint subtype |
      | endpoint 1 | primary       | efficacy         |
      | endpoint 2 | primary       | efficacy         |
    Then I should have endpoints
    And I create a scenario schedule
    Then I should have a scenario schedule
    And I create "2" study activities containing "blo"
    Then I should have study activities
    And I create study events:
      | event   | encounter type   | visit type |
      | visit 1 | visit_outpatient | treatment  |
      | visit 2 | visit_outpatient | treatment  |
    Then I should have study events
    And I create study cells:
      | activity   | event   |
      | activity 1 | visit 1 |
      | activity 2 | visit 2 |
    Then I should have study cells
