Feature: End to End Activation Code Registration Test

  @Release2015.2.0
  @PatientCloud
  @PB130348
  @smoketest
  @selenium
  @Headed
  Scenario: Patient is able to register with valid activation code for different language/country code combinations

    Given I have a valid activation code for a subject
    And I navigate to minotaur activate page
    And I take a screenshot
    When In Minotaur I enter a valid activation code
    And I take a screenshot
    Then In Minotaur I should be able to navigate to the "welcome" page
    And I take a screenshot
    Then In Minotaur I should be able to navigate to the "introduction" page
    And I take a screenshot
    Then In Minotaur I should be able to navigate to the "email" page
    And I take a screenshot
    And In Minotaur I should enter patient email value
    And In Minotaur I should enter patient confirmation email value
    And I take a screenshot
    Then In Minotaur I should be able to navigate to the "password" page
    And In Minotaur I should enter patient password value
    And In Minotaur I should enter password confirmation value
    And I take a screenshot
    Then In Minotaur I should be able to navigate to the "security_question" page
    And I take a screenshot
    And In Minotaur I should see the create-account button not enabled
    And In Minotaur I should enter security question value
    And In Minotaur I should enter security answer value
    And I take a screenshot
    Then In Minotaur I should be able register the user
    And In Minotaur I should see the message "You are now registered for Patient Cloud in this study. Last step is to download the Patient Cloud app and log in."
    And I take a screenshot
    And I am able to login to "iMedidata"
    And I logout from "iMedidata"


