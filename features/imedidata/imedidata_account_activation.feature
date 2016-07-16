Feature: Activating an iMedidata user through email

  @wip
  Scenario: Activating the user through email with one business step
    And the user with email "jsmith@gmail.com" activates the account using the required values below:
      | Username | First | Last  | Email            | Phone        | Select Timezone         | Select Locale | Password | Security Question        | Answer |
      | jsmith42 | John  | Smith | jsmith@gmail.com | 123-456-7890 | (GMT+00:00) - UTC - UTC | English       | Secret1! | What year were you born? | 1970   |

  @wip
  Scenario: Activating the user through email, old school way
    Given I have the iMedidata user activation link in email
    And I navigate to the iMedidata User Activation page
    And I verify I am on the iMedidata User Activation page
    And I take a screenshot
    And I enter in the following required iMedidata User Activation fields:
      | Username | First | Last  | Email            | Phone        | Select Timezone         | Select Locale | Password | Security Question        | Answer |
      | jsmith42 | John  | Smith | jsmith@gmail.com | 123-456-7890 | (GMT+00:00) - UTC - UTC | English       | Secret1! | What year were you born? | 1970   |
    And I take a screenshot
    And I click on Activate button
    Then I should be on the iMedidata Login page
    And I login to iMedidata with Activated User
    And I should be on the iMedidata User Agreement page
    When I acknowledge the User Agreement page
    Then I should be on the iMedidata Home page