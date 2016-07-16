  Feature: Balance Core Scenarios (Scenarios for the major components in balance). Run after code changes.
  These scenarios will test the main workflow of the balance application and will be used to detect new bugs and issues.

  Background:
    Given I login to "iMedidata" as user "balancemistuser"
    Then I search for study "MIST Smoke Test - Do Not Alter!"
    Then I select app "BalanceSandbox" from search results

  #Draft scenarios

  @Balance
  @PB152997-01
  Scenario: I want to create an arm(s) with an associated arm ratio and code for my study.
    Given In Balance I add arm "Test Arm 1" with a ratio of 2 and code "4"
    Then In Balance I verify the "study arms" table has contents of:
      | Name       | Code | Ratio |
      | Test Arm 1 | 4    | 2     |
    And In Balance I logout

  @Balance
  @PB152997-02
  Scenario: I want to update an arm ratio within my study.
    Given In Balance I update arm "Test Arm 1" ratio to 3
    Then In Balance I verify the "Ratio" column of "study arms" table does not contain "2"
    Then In Balance I verify the "study arms" table has contents of:
      | Name       | Code | Ratio |
      | Test Arm 1 | 4    | 3     |
    And In Balance I logout

  @Balance
  @PB152997-03
  Scenario: I create a randomization factor for my study.
    Given In Balance I create randomization factor "Age" with states "Young,MiddleAge,Old"
    Then In Balance I verify the "randomization factors" table has contents of:
      | Factor | Values                |
      | Age    | Young, MiddleAge, Old |
    And In Balance I logout

  @Balance
  @PB152997-04
  Scenario: I create an article types(s) for my study.
    Given In Balance I create article type with the following attributes:
      | Name       | Fixitol 10mg     |
      | Components | Metal,Linen,silk |
    And I wait for "2" seconds
    Then In Balance I verify the "article types" table has contents of:
      | Name                                     |
      | Fixitol 10mg Numbered Blinded Components |
    And In Balance I logout

  @Balance
  @PB152997-05
  Scenario: I create an unnumbered article types(s) for my study.
    Given In Balance I create article type with the following attributes:
      | Name       | Syringe     |
      | Components | Linen,Metal |
      | Unnumbered | Yes         |
      | Open Label | Yes         |
    And I wait for "2" seconds
    Then In Balance I verify the "article types" table has contents of:
      | Name                                     |
      | Syringe Unnumbered Open-Label Components |
    And In Balance I logout

  @Balance
  @PB152997-06
  Scenario: I create a treatment composition for my study.
    Given In Balance I create a treatment "First Round" with DND of "30" and a composition of "1XSyringe"
    And I wait for "2" seconds
    Then In Balance I verify the "treatment compositions" table has contents of:
      | Treatment   | Composition | Do Not Dispense (Days) |
      | First Round | 1X Syringe  | 30                     |
    And In Balance I logout

  @Balance
  @PB152997-07
  Scenario: I create a dosing factor for my study which is associated with several dosing factor levels.
    Given In Balance I create dosing factor "Weight" with levels "Skinny,Average,Fat"
    And I wait for "2" seconds
    Then In Balance I verify the "dosing factors" table has contents of:
      | Factor | Levels              |
      | Weight | Skinny, Average,Fat |
    And In Balance I logout

  @Balance
  @PB152997-08
  Scenario: I enable titration for my study.
    Given In Balance I create scheduled titration level set "Test" with levels "test" and initial dose of "1"
    And In Balance I logout

  @Balance
  @PB152997-09
  Scenario: I want to activate a shipment for my study.
    Given In Balance I assign site "Test Site 001" to depot "Depot1"
    And In Balance I assign site "Test Site 001" to supply plan "Supply Plan 1"
    Then In Balance I activate shipping for site "Test Site 001"
    Then In Balance I verify the "sites" table has contents of:
      | Name          | Depot  | Supply Plan   | Shipping Status |
      | Test Site 001 | Depot1 | Supply Plan 1 | Active          |
    And In Balance I logout

  @Balance
  @PB152997-10
  Scenario: I deactivate a site within my study.
    Given In Balance I deactivate shipping for site "Test Site 001"
    Then In Balance I verify the "sites" table has contents of:
      | Name          | Depot  | Supply Plan   | Shipping Status |
      | Test Site 001 | Depot1 | Supply Plan 1 | Inactive        |
    And In Balance I logout

  @Balance
  @PB152997-11
  Scenario: I upload a packlist file within my study
    Given In Balance I upload packlist "packlist 1" containing 300 items with file path "features/balance/support/packlists/300-items-fixitol.csv"
    Then In Balance I verify the "packlist upload" table has contents of:
      | Name       | Uploaded by                    | Items | Status    |
      | packlist 1 | Balance MIST (balancemistuser) | 300   | Available |

  @Balance
  @PB152997-12
  Scenario: I create a unnumbered Lot, add items, then release it, within my study.
    Given In Balance I create lot with options:
      | lot name            | lot one     |
      | article type        | Syringe     |
      | expiry date         | 31 Dec 2018 |
      | depot               | Depot1      |
      | unnumbered quantity | 500         |
      | pack run id         | 0982047     |
    And In Balance I release lot "lot one" with signature "TestUser"
  #Navigation step will eventually be updated
    And In Balance I navigate to the Lots Page
    Then In Balance I verify the "lots" table has contents of:
      | Lot ID               | Expiry Date | Pack Run ID | Status   | Items in Lot |
      | lot one (unnumbered) | 31 Dec 2018 | 0982047     | Released | 500          |
    And In Balance I logout

  @Balance
  @PB152997-13
  Scenario: I create a numbered Lot, add items, then release it, within my study.
    Given In Balance I create lot with options:
      | lot name    | lot two     |
      | expiry date | 31 Dec 2018 |
      | depot       | Depot1      |
      | pack run id | 0982047535  |
    And In Balance I add items "Fixitol 20mg" to lot "lot two"
    And In Balance I release lot "lot two" with signature "TestUser"
  #Navigation step will eventually be updated
    And In Balance I navigate to the Lots Page
    Then In Balance I verify the "lots" table has contents of:
      | Lot ID  | Expiry Date | Pack Run ID | Status   | Items in Lot |
      | lot two | 31 Dec 2020 | 0982047535  | Released | 150          |
    And In Balance I logout

  @Balance
  @PB152997-14
  Scenario: I create a unnumbered manual shipment for my study.
    Given In Balance I create a manual shipment with origin "Depot1" and destination "Test Site 001" containing articles:
      | Article Name | Quantity |
      | Syringe      | 5        |
    When In Balance I wait 10 seconds for shipment "10001" to be generated
    Then In Balance I verify the "shipments" table has contents of:
      | Name  | Status    | Destination   | Origin | # of Inventory Items |
      | 10001 | Requested | Test Site 001 | Depot1 | 5                    |
    And In Balance I logout

  @Balance
  @PB152997-15
  Scenario: I create a numbered manual shipment for my study.
    Given In Balance I create a manual shipment with origin "Depot1" and destination "Test Site 001" containing articles:
      | Article Name | Quantity |
      | Fixitol 20mg | 3        |
    When In Balance I wait 10 seconds for shipment "10002" to be generated
    Then In Balance I verify the "shipments" table has contents of:
      | Name  | Status    | Destination   | Origin | # of Inventory Items |
      | 10002 | Requested | Test Site 001 | Depot1 | 3                    |
    And In Balance I logout

  @Balance
  @PB152997-16
  Scenario: I want to confirm that a shipment is received within my study.
    Given In Balance I confirm shipment "10001" received
    Then In Balance I verify the "shipments" table has contents of:
      | Name  | Status   | Destination   | Origin | # of Inventory Items |
      | 10001 | Received | Test Site 001 | Depot1 | 5                    |
    And In Balance I logout

  @Balance
  @PB152997-17
  Scenario: I waste items within my study.
    Given In Balance select status "Available" on the by item page
    And In Balance I will select Depot fat header selection "Depot1"
    When In Balance I waste items with reason "Because I want to"
    Then In Balance I verify the "Status" column of "article types" table does not contain "Available"
    And In Balance I logout

  @Balance
  @PB152997-18
  Scenario: I want to generate a rand list for my study.
    Given In Balance I generate rand list "Test List" with options:
      | Arm        | Active | 2   |     |
      | Rand ID    | Random | 100 | 200 |
      | Block Size | 6      | 5   |     |
    Then In Balance I verify the "rand list" table has contents of:
      | Name      | Uploaded By  | Unused | All |
      | Test List | Balance Mist | 5      | 5   |
    And In Balance I logout

  @Balance
  @PB152997-19
  Scenario: I want to set up the randomize and dispense options for my study.
    Given In Balance I set the following randomize and dispense options
      | All Arms | True |
    And In Balance I logout

  @Balance
  @PB152997-20
  Scenario: I want to assign a treatment and verify filters within my study.
    Given In Balance I assign treatment "Testing Treatment" to a filter of:
      | Arm          | blah |
      | Weight Level | All  |
    And In Balance I logout

  @Balance
  @PB152997-21
  Scenario: I want to revoke release a specified lot within my study.
    Given In Balance I revoke release from lot "lot one" with audit reason "This is a test"
    Then In Balance I verify the "lots" table has contents of:
      | Lot ID               | Expiry Date | Pack Run ID | Status   | Items in Lot |
      | lot one (unnumbered) | 31 Dec 2018 | 0982047     | Released | 500          |
    And In Balance I logout

  @Balance
  @PB152997-22
  Scenario: I want to enable quarantining within the study property page for my study.
    Given In Balance I enable quarantining at site with file upload option "Allow uploading of files"
    And In Balance I logout

  @Balance
  @PB152997-23
  Scenario: I quarantine items within my study.
    Given In Balance select status "Available" on the by item page
    And In Balance I will select Depot fat header selection "Depot1"
    When In Balance I quarantine items with reason "Because I want to"
    Then In Balance I verify the "Status" column of "article_types_table" table does not contain "Available"
    And In Balance I logout

  @Balance
  @PB152997-24
  Scenario: I want to download the inventory item list page for my study.
    Given In balance I download inventory item list
    Then In Balance I verify the flash message "Your download is being prepared. You will receive a notification with a download link when it is ready."
    Then In Balance I verify and close the notification message "Your inventory items list can be downloaded here."
    And In Balance I logout

  @Balance
  @PB152997-25
  Scenario: I want to setup and execute a simulation for my study
    Given In Balance I want to fill out the new simulation setup settings:
      | Simulation Name    | TestSim |
      | Number of Runs     | 10      |
      | Number of Subjects | 10      |
      | Number of Sites    | 5       |
    When In Balance I execute for simulation "TestSim"
    And I wait for "3" seconds
    Then In Balance I verify the "simulation setup" table has contents of:
      | Name    | Number of Runs | Number of Subjects | Number of Sites | Strata Distribution Ratios      |
      | TestSim | 10             | 10                 | 5               | Young (1) MiddleAge (1) Old (1) |
    And In Balance I logout

  @Balance
  @PB152997-26
  Scenario:I want to download a list for a specified simulation
    Given In Balance I download a list for simulation result "TestSim"
    Then In Balance I verify the flash message "Your download is being prepared. You will receive a notification with a download link when it is ready."
    Then In Balance I verify and close the notification message "Your simulated subject list can be downloaded here."
    And In Balance I logout

  @Balance
  @PB152997-27
  Scenario: I want to download a subject list within my study
    Given In Balance I download a subject list
    Then In Balance I verify the flash message "Your download is being prepared. You will receive a notification with a download link when it is ready."
    Then In Balance I verify and close the notification message "Your subject list can be downloaded here."
    And In Balance I logout

  @Balance
  @PB152997-28
  Scenario: I want to generate the subject treatment report within my study
    Given In Balance I select the subject treatment report
    Then In Balance I verify the flash message "Your download is being prepared. You will receive a notification with a download link when it is ready."
    Then In Balance I verify and close the notification message "Your subject treatment report can be downloaded here."
    And In Balance I logout

  @Balance
  @PB152997-29
  Scenario: I want to generate the subject distribution report within my study
    Given In Balance I select the subject distribution report
    Then In Balance I verify the flash message "Your download is being prepared. You will receive a notification with a download link when it is ready."
    Then In Balance I verify and close the notification message "Your subject distribution report can be downloaded here."
    And In Balance I logout

  @Balance
  @PB152997-30
  Scenario: I want to manually dispense an item to a subject within my study
    Given In Balance I manually dispense to subject "Boulder" under visit "1", and Article Type "100mg placebo" with reason "Test" dispensing 3 "Item-17"
    And In Balance I logout

  @Balance
  @PB152997-31
  Scenario: I want to unblind a specified subject within my study
    Given In Balance I unblind subject "Boulder" with reason "Because I can"
    Then In Balance I verify the "subject_unblind" table has contents of:
    |Reason for Unblinding|
    |Because I can        |
    And In Balance I logout
