Feature: Test the basic full round trip integration from Rave to Coder back to Rave


@DFT
@PB0.0.0-001
@Release2014.2.0
Scenario: A MedDRA term can be submitted in Rave to Coder, coded in Coder where the coded decision is able to be seen in Rave

  Given I login to "imedidata" as user "coderpr_14"
  And I have the following data set:
    | Key                    | Value                 |
    | Randomized MedDRA Term | TERRIBLE HEAD PAIN<l> |
  When I navigate to "Rave EDC" for study group "CoderPRStudy14" from iMedidata
  And I add a subject in Rave with the following data:
    | Field Name | Type | Value      |
    | Name       | text | Subject<l> |
  And I navigate to form "meddraform" in Rave
  And I enter the following data for the "meddraform" Rave form:
    | Field Name    | Type      | Value                  |
    | Adverse Event | long_text | Randomized MedDRA Term |
  And I save Rave EDC form
  And I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "CoderPRStudy14" from iMedidata
  And I search for term "Randomized MedDRA Term" and wait for result
  And I Browse and Code Term "Randomized MedDRA Term" on row 1, entering value "headache" and selecting dictionary tree row 5 and "Create Synonym"
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "CoderPRStudy14" from iMedidata
  And I search for subject "sub_name" for study named "CoderPRStudy14" and site "CoderPRSite14"
  And I open log line "1" for datapoint "Randomized MedDRA Term" on form "meddraform"
  Then I verify the following EDC fields data:
    | terrible head pain       |
    | SOC                      |
    | Nervous system disorders |
    | 10029205                 |
    | HLGT                     |
    | Headaches                |
    | 10019231                 |
    | HLT                      |
    | Headaches NEC            |
    | 10019233                 |
    | PT                       |
    | Headache                 |
    | 10019211                 |
  And I take a screenshot
  And I logout from "rave"

@DFT
@PB0.0.0-002
@Release2014.2.0
Scenario: Multiple WhoDrug terms with a supplement can be submitted in Rave to Coder, coded in Coder where the coded decisions are able to be seen in Rave

  Given I login to "imedidata" as user "coderpr_14"
  And I have the following data set:
    | Key                       | Value                          |
    | Randomized WhoDrug Term   | MEDICINE FOR PAIN DOWN LEG<l>  |
    | Randomized WhoDrug Term 2 | MEDICINE FOR PAIN DOWN LEG2<l> |
  When I navigate to "Rave EDC" for study group "CoderPRStudy14" from iMedidata
  And I add a subject in Rave with the following data:
    | Field Name | Type | Value      |
    | Name       | Text | Subject<l> |
  And I navigate to form "whodrugform" in Rave
  And I enter the following data for the "whodrugform" Rave form:
    | Field Name | Type      | Value                   |
    | Medication | long_text | Randomized WhoDrug Term |
    | Indication | Text      | INDICATION              |
  And I save Rave EDC form
  And I add a Log Line in Rave EDC
  And I enter the following data for the "whodrugform" Rave form:
    | Field Name | Type      | Value                     |
    | Medication | long_text | Randomized WhoDrug Term 2 |
    | Indication | Text      | INDICATION2               |
  And I save Rave EDC form
  And I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "CoderPRStudy14" from iMedidata
  And I search for term "Randomized WhoDrug Term" and wait for result
  And I select term "Randomized WhoDrug Term" in Coder Main Table on row "1"
  Then I verify the following in Source Term tab for Supplements table:
    | Supplement Term     | Supplement Value |
    | WHODRUGFORM.COMPANY | INDICATION       |
  And I verify the following data in Reference Table:
    | Name    | Value         |
    | Field   | WHODRUGTERM   |
    | Line    | 1             |
    | Form    | whodrugform   |
    | Event   | SUBJECT       |
    | Subject | sub_name      |
    | Site    | CoderPRSite14 |
  And I take a screenshot
  And I search for term "Randomized WhoDrug Term" and wait for result
  When I open a query with query text "Rejecting Decision due to bad term" for term "Randomized WhoDrug Term" on row 1
  And I wait for term "Randomized WhoDrug Term" on row "1" to appear with Query status "Open"
  And I search for term "Randomized WhoDrug Term 2" and wait for result
  And I Browse and Code Term "Randomized WhoDrug Term 2" on row 1, entering value "BAYER CHILDREN'S COUGH" and selecting dictionary tree row 6 and "Create Synonym"
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "CoderPRStudy14" from iMedidata
  And I search for subject "sub_name" for study named "CoderPRStudy14" and site "CoderPRSite14"
  And I open log line "1" for datapoint "Randomized WhoDrug Term" on form "whodrugform"
  Then I verify icon Query Open displayed for field "Medication" on Rave form
  And I verify query text "Rejecting Decision due to bad term" is displayed for the field "Medication" on Rave form
  And I take a screenshot
  When I open log line "2" for datapoint "Randomized WhoDrug Term 2" on form "whodrugform"
  Then I verify icon Complete displayed for field "Medication" on Rave form
  And I take a screenshot
  When I open log line "2" for datapoint "Randomized WhoDrug Term 2" on form "whodrugform"
  Then I verify the following EDC fields data:
    | ATC                                         |
    | RESPIRATORY SYSTEM                          |
    | R                                           |
    | ATC                                         |
    | COUGH AND COLD PREPARATIONS                 |
    | R05                                         |
    | ATC                                         |
    | COUGH SUPPRESSANTS, EXCL. COMBINATIONS WITH |
    | R05D                                        |
    | ATC                                         |
    | OPIUM ALKALOIDS AND DERIVATIVES             |
    | R05DA                                       |
    | PRODUCT                                     |
    | BAYER CHILDREN'S COUGH                      |
    | 007574 01 001 8                             |
  And I take a screenshot
  And I logout from "Rave"
