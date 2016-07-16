Feature: Test the basic full round trip integration from Rave to Coder back to Rave


@DFT
@PB1.0.0-001
@Release2014.2.0
Scenario: A MedDRA term can be submitted in Rave to Coder, coded in Coder where the coded decision is able to be seen in Rave

  Given I login to "imedidata" as user "CoderPR14"
  And I have the following data set:
    | Key                    | Value                 |
    | Randomized MedDRA Term | TERRIBLE HEAD PAIN<l> |
  When I navigate to "Rave EDC" for study group "Rave PreRelease Study 2014.1.0 (Coder)" from iMedidata
  And I add a subject in Rave with the following data:
    | Field Name | Type | Value      |
    | Name       | Text | Subject<l> |
  And I navigate to form "Adverse Events" in Rave within folders:
    | Folder         |
    | Adverse Events |
  And I enter the following data for the "<string>" Rave form:
    | Field Name | Type | Value                  |
    | Coder AE   | Text | Randomized MedDRA Term |
  And I save Rave EDC form
  And I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "Medidata App Monitoring" from iMedidata
  And I search for term "Randomized MedDRA Term" and wait for result
  And I Browse and Code Term "Randomized MedDRA Term" on row 1, entering value "headache" and selecting dictionary tree row 5 and "Create Synonym"
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "Medidata App Monitoring" from iMedidata
  And I search for subject "Subject_you_created" for study named "Rave PreRelease Study 2014.1.0 (Coder)" and site "North Short LIJ Test Site"
  And I open log line "1" for datapoint "Randomized MedDRA Term" on form "Adverse Events"
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
@PB1.0.0-002
@Release2014.2.0
Scenario: Multiple WhoDrug terms with a supplement can be submitted in Rave to Coder, coded in Coder where the coded decisions are able to be seen in Rave

  Given I login to "imedidata" as user "CoderPR14"
  And I have the following data set:
    | Key                       | Value                          |
    | Randomized WhoDrug Term   | MEDICINE FOR PAIN DOWN LEG<l>  |
    | Randomized WhoDrug Term 2 | MEDICINE FOR PAIN DOWN LEG2<l> |
  When I navigate to "Rave EDC" for study group "Rave PreRelease Study 2014.1.0 (Coder)" from iMedidata
  And I add a subject in Rave with the following data:
    | Field Name | Type | Value      |
    | Name       | Text | Subject<l> |
  And I navigate to form "Concomitant Medications" in Rave within folders:
    | Folder                  |
    | Concomitant Medications |
  And I enter the following data for the "<string>" Rave form:
    | Field Name   | Type | Value                   |
    | Coder ConMed | Text | Randomized WhoDrug Term |
    | Route:       | Text | Intramuscular           |
  And I save Rave EDC form
  And I add a Log Line in Rave EDC
  And I enter the following data for the "<string>" Rave form:
    | Field Name   | Type | Value                     |
    | Coder ConMed | Text | Randomized WhoDrug Term 2 |
    | Route:       | Text | Oral                      |
  And I save Rave EDC form
  And I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "Medidata App Monitoring" from iMedidata
  And I search for term "Randomized WhoDrug Term" and wait for result
  And I select term "Randomized WhoDrug Term" in Coder Main Table on row "1"
  Then I verify the following in Source Term tab for Supplements table:
    | Supplement Name        | Supplement Value |
    | CONMEDS.CONMED_CMROUTE | Intramuscular    |
  And I verify the following data in Reference Table:
    | Name    | Value                     |
    | Field   | CMCODER                   |
    | Line    | 1                         |
    | Form    | Concomitant Medications   |
    | Event   | CM                        |
    | Subject | Subject_you_created       |
    | Site    | North Short LIJ Test Site |
  And I take a screenshot
  When I open a query with query text "Rejecting Decision due to bad term" for term "Randomized WhoDrug Term" on row 1
  And I search for term "Randomized WhoDrug Term" and wait for result
  And I search for term "Randomized WhoDrug Term 2" and wait for result
  And I Browse and Code Term "Randomized WhoDrug Term 2" on row 2, entering value "BAYER CHILDREN'S COUGH" and selecting dictionary tree row 6 and "Create Synonym"
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "Medidata App Monitoring" from iMedidata
  And I search for subject "Subject_you_created" for study named "Rave PreRelease Study 2014.1.0 (Coder)" and site "North Short LIJ Test Site"
  And I open log line "1" for datapoint "Randomized WhoDrug Term" on form "Concomitant Medications"
  Then I verify icon Query Open displayed for field "Coder ConMed" on Rave form
  And I verify query text "Rejecting Decision due to bad term" is displayed for the field "Coder ConMed" on Rave form
  And I take a screenshot
  When I open log line "2" for datapoint "Randomized WhoDrug Term 2" on form "Concomitant Medications"
  Then I verify the following EDC fields data:
    | ATC                                              |
    | RESPIRATORY SYSTEM                               |
    | R                                                |
    | ATC                                              |
    | COUGH AND COLD PREPARATIONS                      |
    | R05                                              |
    | ATC                                              |
    | COUGH SUPPRESSANTS EXCL. COMB. WITH EXPECTORANTS |
    | R05D                                             |
    | ATC                                              |
    | OPIUM ALKALOIDS AND DERIVATIVES                  |
    | R05DA                                            |
    | PRODUCT                                          |
    | BAYER CHILDREN'S COUGH                           |
    | 007574 01 001 8                                  |
  And I logout from "Rave"

