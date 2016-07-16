Feature: End to End Subject Enroll Test
  As provider
  I want to enroll subjects to a study and site
  So they can use patient cloud

  @Release2015.2.0
  @PatientCloud
  @PB130348
  @selenium
  @Headed
  Scenario: Provider is able invite a subject to a study
    Given I added a subject in Rave for patient management
    When I login to patient management as "test_user"
    And In Patient Management I navigate to the study-site page
    And I take a screenshot
    And In Patient Management I select study and site
    And I take a screenshot
    And In Patient Management I navigate to invite page
    And I take a screenshot
    And In Patient Management I enter subject,initials and language
    And I take a screenshot
    And In Patient Management I invite the subject
    Then In Patient Management I can see activation code in the table
    And In Patient Management I can see that the subject and initials fields are cleared
    And I take a screenshot
    And I logout from patient management
    And I take a screenshot
