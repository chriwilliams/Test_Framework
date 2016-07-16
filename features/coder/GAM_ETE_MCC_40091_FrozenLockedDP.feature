Feature: EDC will still be able to receive coding decisions even when the field has been locked or frozen.

@WIP
@PBMCC40091-004
@ReleaseRave2013.1.0
Scenario:  A coding decision and coder query will still be processed in Rave even if the forms have been locked
  Given I login to "imedidata" as user "rave_coder<id>"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I set coder and rave defaults with the following options:
    |Dictionary     |MedDRA          |
    |version        |11.0            |
    |locale         |ENG             |
    |syn_list_name  |Primary         |
    |primary_path   |OFF             |
    |Synonym_Policy |Active          |
    |project        |RaveCoderSP<id> |
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I navigate to "Forms" for Form "ETE1" in Draft "Draft 1" for Project "RaveCoderSP<id>"
  And I setup the field "Coder Term 1" to use dictionary "CODER- MedDRA"
  And I select Project tab in Rave
  And I Publish and Push Draft "Draft 1" as "ETE1Draft<l>" in "Prod" environment to All sites
  And I add a subject for study "RaveCoderSP<id>" and site "Active Site" with following values:
    |label              |value          |
    |Subject Initials   |ETE1           |
    |Subject Number     |Mediflex<l>    |
  And I submit verbatim term for the following field on "ETE1" form:
    | Field Name   | Type      | Value              |
    | Coder Term 1 | long_text | TERRIBLE HEAD PAIN |
  And I add another log line for Form "ETE1"
  And I submit verbatim term for the following field on "ETE1" form:
    | Field Name   | Type      | Value                           |
    | Coder Term 1 | long_text | SECOND WORST TERRIBLE HEAD PAIN |
  And I enable hard lock on form "ETE1"
  And I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And in Coder, I wait for 2 tasks to show up in the task page
  Then in Coder, I should see verbatim term "TERRIBLE HEAD PAIN" located in Coder Main Table
  And in Coder, I should see verbatim term "SECOND WORST TERRIBLE HEAD PAIN" located in Coder Main Table
  And I take a screenshot
  And in Coder, I Browse and Code Term "TERRIBLE HEAD PAIN" on row 1, entering value "HEADACHE" and selecting dictionary tree row 5 and "Do Not Create Synonym"
  When in Coder, I open a query with query text "Test Query to Rave" for term "SECOND WORST TERRIBLE HEAD PAIN" on row 1
  Then in Coder, I wait for term "SECOND WORST TERRIBLE HEAD PAIN" on row "1" to appear with Query status "OPEN"
  And I take a screenshot
  When I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup18" from iMedidata
  And I search for subject "Subject_you_created" for study named "RaveCoderSP<id>" and site "Active Site"
  And I open log line 1 for Coder datapoint "TERRIBLE HEAD PAIN" on form "ETE1"
  Then I verify the following EDC fields data:
    |terrible head pain         |
    |SOC                        |
    |Nervous system disorders   |
    |10029205                   |
    |HLGT                       |
    |Headaches                  |
    |10019231                   |
    |HLT                        |
    |Headaches NEC              |
    |10019233                   |
    |PT                         |
    |Headache                   |
    |10019211                   |
  And I take a screenshot
  When I open log line 2 for Coder datapoint "SECOND WORST TERRIBLE HEAD PAIN" on form "ETE1"
  Then I should see 2 Rave Query Icon
  Then I verify icon Query Open displayed for field "" on Rave form
  And I expect to see value "test query" on form "ETE1"
  And I take a screenshot
  And I logout from "Rave"
