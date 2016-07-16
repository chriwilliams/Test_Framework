# Only run this if study does not exist in your environment (validation/sandbox/etc...)
Feature: Initial Study Setup for Balance - RaveX Randomization not coupled with Dispensation

  # This feature file assumptions
  #
  # Client Division Bal_MIST_E2E exists with:
  #   - balancemistuser is an Admin user in Client Division
  #   - Depot1 Created in Client Division
  #   - Role all_apps exists with access to all applications (balance, ravex, rave architect)

  @Balance
  @Release2015.3.0
  @PB148749-001a
  Scenario: Create Study Bal_RaveX_Integration_01 in MCCAdmin for Balance/RaveX integration
    Given I login to "iMedidata" as user "balancemistuser"
    And In iMedidata I navigate to "MCCAdmin" for study group "Bal_MIST_E2E"
    And I take a screenshot
    And In MCCAdmin I create a study using the values below:
      | Protocol ID              | Use Protocol ID | Study Name                 | Primary Indication       | Secondary Indication | Phase   | Configuration Type          | Test Study |
      | Bal_RaveX_Integration_01 | False           | Bal_RaveX_Integration_01   | Intracerebral Hemorrhage | Acute Pancreatitis   | Phase I | Bal_MCC_Integ_E2E           | False      |
    And I take a screenshot
    And In MCCAdmin I add new user to study "Bal_RaveX_Integration_01" using the value below:
      | First     | Last   | Email                          | Environment             | Roles    |
      | Balance   | MIST   | balancemistuser@gmail.com      | Production              | all_apps |
    And I take a screenshot
    And In MCCAdmin I create study site using the values below:
      | Site Name          | Client Division Site Number | Site Number | Street Address | Zip    | City | Country       | State    | Study Environment | Principal Investigator Email   | Principal Investigator First Name | Principal Investigator Last Name | Principal Investigator Role |
      | Balance Site 01    | 100001                      | 100         | 350 Hudson St  | 11222  | NY   | United States | New York | Production        | balancemistuser+pi@gmail.com   | Admin PI                          | User100                          | all_apps                    |
    And I take a screenshot
    And In MCCAdmin I select environment "Production" from the filter group
    And In MCCAdmin I navigate to "Manage Depots" page
    And In iMedidata I add depots "Depot1" to the selected study
    And I take a screenshot
    And I logout from "iMedidata"

#    # Balance setup
    Given I login to "iMedidata" as user "balancemistuser"
    When I search for study "Bal_RaveX_Integration_01"
    And I take a screenshot
    Then I select app "BalanceValidation" from search results
    And I am running the study design wizard having chosen options:
      | Study Design            | Randomization and Supplies Management |
      | Blinding Restrictions   | Yes                                   |
      | Design Setup            | Start from scratch                    |
      | Randomization Type      | Dynamic Allocation                    |
      | Quarantining            | No                                    |
      | Enrollment Caps         | No                                    |
    And I take a screenshot

    And In Balance I add arm "Test Arm 1" with a ratio of 1
    And In Balance I add arm "Test Arm 2" with a ratio of 1
    And In Balance I create randomization factor "GENDER" with a weight of 1 and states "Male,Female"
    And In Balance I create randomization factor "AGEGROUP" with a weight of 1 and states "Under 30,30 - 50,Over 50"
    And In Balance I create randomization factor "SMOKER" with a weight of 1 and states "Yes,No"
    Then In Balance I set the following randomize and dispense options
      | Rand and Dispense Option | Not Coupled       |
    And I take a screenshot

    When In Balance I create article type with the following attributes:
      | Name | Fixitol 10mg |
    And In Balance I create article type with the following attributes:
      | Name | Fixitol 20mg |
    And In Balance I create article type with the following attributes:
      | Name        | Syringe |
      | Unnumbered  | Yes     |
      | Open Label  | Yes     |
    When In Balance I create a treatment "Treatment 1" with DND of "30" and a composition of "1XFixitol 10mg,1XSyringe"
    When In Balance I create a treatment "Treatment 2" with DND of "30" and a composition of "1XFixitol 20mg,1XSyringe"
    And In Balance I create dosing factor "WEIGHT" with levels "Heavy,Light"
    And I take a screenshot

    When In Balance I create a visit schedule with 5 visits, an offset of 7, start window of 2, end window of 3, and rand visit 2
    And In Balance I update multiple visit names with values below:
      | Old Visit Name | New Visit Name  |
      | Visit 1        | Screening       |
      | Visit 2        | Visit 1         |
      | Visit 3        | Visit 2         |
      | Visit 4        | Visit 3         |
      | Visit 5        | Visit 4         |
    And In Balance I set dosing for visit "Visit 1" to on
    And I take a screenshot

    # Assign Treatments Setup
    When In Balance I assign treatment "Treatment 1" to a filter of:
      | Arm | Test Arm 1 |
    When In Balance I assign treatment "Treatment 2" to a filter of:
      | Arm | Test Arm 2 |
    And I take a screenshot

    When In Balance I upload packlist "packlist 1" containing 300 items with file path "features/balance/support/packlists/300-items-fixitol.csv"
    And I wait for "3" seconds
    Then In Balance I create lot with options:
      | lot name            | lot one      |
      | article type        | Syringe      |
      | expiry date         | 31 Dec 2021  |
      | depot               | Depot1       |
      | unnumbered quantity | 1000         |
    And In Balance I release lot "lot one" with signature "test user"
    Then In Balance I create lot with options:
      | lot name    | lot two     |
      | expiry date | 31 Dec 2018 |
      | depot       | Depot1      |
    And In Balance I add items "Fixitol 10mg,Fixitol 20mg" to lot "lot two"
    And In Balance I release lot "lot two" with signature "test user"
    And I take a screenshot

    # Go to Sites Page to sync sites
    And In Balance I navigate to the Manage Sites Page

    # Create and confirm shipment
    Then In Balance I create a manual shipment with origin "Depot1" and destination "Balance Site 01 (Inactive)" containing articles:
      | Article Name | Quantity |
      | Fixitol 10mg | 150      |
      | Fixitol 20mg | 150      |
      | Syringe      | 200      |
    And In Balance I wait 30 seconds for shipment "10001" to be generated
    And In Balance I confirm shipment "10001" received
    Then In Balance I follow the iMedidata Logo
    And I logout from "iMedidata"

