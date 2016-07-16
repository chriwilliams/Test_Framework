Feature: Role Configuration test adding/removing users from Client Division through MCC-Admin

  A user is added to a client division.  That user is able to access the client division and create roles. When the user is removed from the
  client division, Then the user will no longer have access to that client division.

  Pre-testing Assumptions: Client Division exists and client division admin exists for the purpose of add/remove users from client division.

  @Release2014.2.0
  @PB96737-001
  @Draft
  @selenium
  @PlatformService
  Scenario: End to End integration test adding and removing client division users and roles.

    Given I login to "iMedidata" as user "cdautoadmin"
    And I take a screenshot
    And I navigate to "MCCAdmin" for study group "CI AutoTest SG001" from iMedidata
    And I take a screenshot
    And I navigate to Client Division Users page and create admin user using the values below:
      | Email                                | First | Last       | Phone | Role  |
      | cloudadmiral+cdadmin_<r4>@gmail.com  | Marc  | User-<r4>  |       | admin |
    And I take a screenshot
    And I logout from "MCCAdmin"
    And I take a screenshot
    And the user with email "cloudadmiral+cd_user_<r4>@gmail.com" activates the account using the required values below:
      | Username     | First   | Last      | Phone        | Select Timezone                                | Select Locale | Password | Security Question        | Answer |
      | cdadmin_<r4> | Regular | User-<r4> | 098-765-4321 | (GMT+00:00) - UTC - UTC | English       | Secret2! | What year were you born? | 1974   |
    And I take a screenshot
    And I perform actions for invitations in iMedidata using the values below:
      | Name              | Environment| Invitation |
      | CI AutoTest SG001 |            | Accept     |
    And I take a screenshot
    And I navigate to "MCCAdmin" for study group "CI AutoTest SG001" from iMedidata
    And I navigate to Configuration Roles page and add roles using the values below:
      | Name      | Category               | Apps                                                  | Roles             |
      | ClinicOps | Clinical Operations    | cvraveupgrade1 Rave EDC, cvraveupgrade1 Rave Modules  | CDM1, All Modules |
      | PI        | Principal Investigator | cvraveupgrade1 Rave EDC, cvraveupgrade1 Rave Modules  | CDM2, All Modules |
    And I take a screenshot
    And I logout from "MCCAdmin"
    And I take a screenshot
    And I login to "iMedidata" as user "cdautoadmin"
    And I take a screenshot
    And I navigate to "MCCAdmin" for study group "CI AutoTest SG001" from iMedidata
    And I take a screenshot
    And I navigate to Configure Roles page and remove the following roles "PI,ClinicOps"
    And I take a screenshot
    And In Role Configuration I navigate to app "Admin"
    And I navigate to Client Division Users page and remove an admin user
    And I take a screenshot
    And I logout from "MCCAdmin"
    And I take a screenshot
    And I wait for "5" seconds
    When I login to iMedidata with Activated User
    And I take a screenshot
    Then I verify user does not have access to study group "CI AutoTest SG001"
    And I take a screenshot
    And I logout from "iMedidata"

