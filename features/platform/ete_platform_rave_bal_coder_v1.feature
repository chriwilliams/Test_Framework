Feature: Integration of Applications RaveX, Balance, and Coder

  @Release2015.2.0
  @PB165049-001
  @Draft
  @RaveX
  Scenario: To add new subject in RaveX and enter data on required forms
    Given I login to "iMedidata" as user "rave_user"
    And I navigate to "Rave EDC" for study "Platform_Integration_Study01" from iMedidata
    And I add a subject in RaveX with the following data:
      | Field Name                    | Type | Value |
      | Please Enter a Subject Number | text | <r7>  |
    And I take a screenshot
    And I navigate to form "Visit Date" within folders:
      | Folder          |
      | Screening Visit |
    And I enter the following data for the "Visit Date" form:
      | Field Name    | Type | Value      |
      | Date of Visit | date | 01-01-2015 |
    And I save RaveX EDC form
    And I take a screenshot
    And I navigate to form "Balance Subject Register"
    And I enter the following data for the "Balance Subject Register" form:
      | Field Name                                        | Type      | Value |
      | Is the subject ready to be registered in Balance? | check_box | true  |
    And I save RaveX EDC form
    And I take a screenshot
    And I navigate to form "Informed Consent / Inclusion and Exclusion Criteria"
    And I enter the following data for the "Informed Consent / Inclusion and Exclusion Criteria" form:
      | Field Name                                         | Type         | Value |
      | Date of Informed Consent                           | date         | <m>   |
      | Did Subject Meet All Inclusion/Exclusion Criteria? | radio_button | Yes   |
    And I save RaveX EDC form
    And I take a screenshot
    And I navigate to form "Demographics"
    And I enter the following data for the "Demographics" form:
      | Field Name    | Type      | Value     |
      | Date of Birth | date      | 1/1/1979  |
      | Gender        | drop_down | Male      |
      | Race          | drop_down | Caucasian |
    And I save RaveX EDC form
    And I take a screenshot
    And I navigate to form "Visit Date" within folders:
      | Folder                  |
      | Randomization Visit (1) |
    And I enter the following data for the "Visit Date" form:
      | Field Name    | Type | Value |
      | Date of Visit | date | <m>   |
    And I save RaveX EDC form
    And I take a screenshot
    And I navigate to form "Randomisation and Dispense"
    And I enter the following data for the "Randomisation and Dispense" form:
      | Field Name                                         | Type      | Value |
      | Click here to randomize and assign kits to subject | check_box | true  |
    And I save RaveX EDC form
    # Balance - Possibly verify Stratum Name generated field value here
#    And I verify the following data on the "Randomisation and Dispense" form:
#      | Field Name   | Value |
#      | Stratum Name | test  |
    And I take a screenshot
    And I navigate to form "Visit Date" within folders:
      | Folder    |
      | Visit (1) |
    And I enter the following data for the "Visit Date" form:
      | Field Name    | Type | Value |
      | Date of Visit | date | <m>   |
    And I save RaveX EDC form
    And I take a screenshot
    And I navigate to form "Drug Dispensation"
    And I enter the following data for the "Drug Dispensation" form:
      | Field Name                                   | Type      | Value |
      | Click here to receive kit number to dispense | check_box | true  |
    And I save RaveX EDC form
    # Balance - Possibly verify Kit Number generated field value here
#    And I verify the following data on the "Drug Dispensation" form:
#      | Field Name | Value |
#      | Kit Number | test  |
    And I take a screenshot
    # Coder - Next step is for Coder
    And I navigate to form "Adverse Event YN" within folders:
      | Folder             |
      | Adverse Events (1) |
    And I enter the following data for the "Adverse Event YN" form:
      | Field Name                                   | Type         | Value |
      | Has the Subject Experience an Adverse Event? | radio_button | Yes   |
    And I save RaveX EDC form
    And I take a screenshot
    # After all forms are filled out, we should sign all forms from Subject screen

  # MJN - End (Balance and Coder application specific verification should continue from here)

  @Release2015.2.0
  @PB165049-002
  @Draft
  @Coder
  Scenario: Enter verbatim in RaveX, and see auto coded results
    And I login to "imedidata" as user "coderadmin"
    And I navigate to "EDC" for study group "MCC Platform IntegrationTest101" from iMedidata
    And I search for study "Balance-Study-II" in RaveX
    And I select study "Balance-Study-II" in RaveX
    And I navigate to View Sites under study enrollment
    And I add a subject in RaveX with the following data:
      | Field Name     | Type | Value |
      | Subject Number | text | <r7>  |
    And I navigate to form "Adverse Events" within folders:
      | Folder          |
      | Screening Visit |
    And I enter the following data for the "Adverse Events" form:
      | Field Name         | Type      | Value    |
      | Adverse Event Name | long_text | Headache |
    And I save RaveX EDC form
    And I wait for the coded term and id to appear for log line 1 in RaveX:
      | 10019211 |
    And I verify the following Audit Data for field "Adverse Event Name:":
      | Audit                                                                                                                                    |
      | User coded data point as SOC: Nervous system disorders, HLGT: Headaches, HLT: Headaches NEC, PT: Headache, LLT: Headache - version 15.0. |
      | User coded data point as Term Coded data point by User: Coder System - version 15.0.                                                     |
      | Data point term sent to Coder                                                                                                            |
      | User entered 'Headache'                                                                                                                  |
