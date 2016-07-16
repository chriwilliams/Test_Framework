Feature: When a Coder query is answered or cancelled, the verbatim will be resent to Coder.


@WIP
@PBMCC44234-001
@Release2013.1.0
@VY16.JAN.2013
@VER2013.1.0
Scenario: A Coder query in EDC that is answered or cancelled will cause the verbatim to be resent to Coder even if the verbatim is updated or not.
  Given I login to "imedidata" as user "rave_coder<id>"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And in Coder, I set coder defaults with the following options:
    |Dictionary     |MedDRA              |
    |version        |11.0                |
    |locale         |ENG                 |
    |syn_list_name  |Primary             |
    |primary_path   |ON                  |
    |Synonym_Policy |Active              |
    |project        |RaveCoderSP<id>     |
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
#  And I upload Rave file "MCC44234.xls" with draft name "MCC44234" to project "<RaveCoderInvETEProjectB>"
  And I upload draft "MCC44234.xls"
  And I navigate to "Forms" for Form "suppandcomp" in Draft "MCC44234" for Project "RaveCoderSP<id>"
  And I setup the field "Supp" to use dictionary "CODER- WHODRUGDDEB2"
  And I configure dictionary to use "Product" as the coding level
  And I select and save following supplemental fields:
    | Value     |
    | SUPP      |
  And I select Project tab in Rave
  And I Publish and Push Draft "MCC44234" as "CoderDraft<l>" in "Prod" environment to All sites
  And I set rave default settings for Coder
  And I add a subject for study "RaveCoderSP<id>" and site "Active Site" with following values:
    | label            | value       |
    | Subject Initials | SETE1       |
    | Subject Number   | Mediflex<l> |
  And I submit verbatim term for the following field on "ETE1" form:
    | Field Name   | Type      | Value              |
    | Coder Term 1 | long_text | TERRIBLE HEAD PAIN |
  And I submit verbatim term "HEAD PAIN" with supp value of "SUPP1" on form "suppandcomp"
#  Then I should see Medidata Coder Coding Icon
  Then I verify icon Requires Coding displayed for field "put field name"
  And I take a screenshot
  When I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup1<id>" from iMedidata
  And in Coder, I wait for 1 task to show up in the task page
  Then in Coder, I should see verbatim term "HEAD PAIN" located in Coder Main Table
  And I take a screenshot
  When in Coder, I verify the following in Source Term tab for Supplements table:
  |Supplemental Term|Supplemental Value|
  |  MCC42699.SUPP  | Supp1            |
  And I take a screenshot
  When in Coder, I open a query with query text "some test query send to rave" for term "HEAD PAIN" on row 1
  Then in Coder, I wait for term "HEAD PAIN" on row "1" to appear with Query status "Open"
  And I take a screenshot
  When I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveStudyGroup<id>" from iMedidata
  And I search for subject "subjct_from_sticky" for study named "RaveCoderSP<id>" and site "Active Site"
  And I open log line 1 for Coder datapoint "HEAD PAIN" on form "suuppandcomp"
  Then I should see Image "1" Rave Query Icon
  And I expect to see value "test query" on form "suppandcomp"
  And I take a screenshot
  When I answer query for term "CAME FROM RAVE" with "some answer"
  Then I should see Image "Medidata Coder Coding Icon"
  And I take a screenshot
  When I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  Then in Coder, I wait for term "HEAD PAIN" on row "1" to appear with Query status "closed"
  And I should see value "head pain" located in "Coder Main Table"
  And I take a screenshot
  When in Coder, I verify the following in Source Term tab for Supplements table:
    |Supplemental Term|Supplemental Value|
    |  MCC42699.SUPP  | Supp1            |
  And in Coder, I open a query with query text "testing closure of qm" for term "HEAD PAIN" on row 1
  And in Coder, I wait for term "HEAD PAIN" on row "1" to appear with Query status "Open"
  And I take a screenshot
  When I navigate to iMedidata from "coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I search for subject "subjct_from_sticky" for study named "RaveCoderSP<id>" and site "Active Site"
  And I open log line 1 for Coder datapoint "HEAD PAIN" on form "suuppandcomp"
  Then I should see "1" Rave Query Icon
  And I expect to see value "testing closure of qm" on form "suppandcomp"
  And I close query for term "term name here"
  And I take a screenshot
  When I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And in Coder, I wait for 1 task to show up in the task page
  Then in Coder, I wait for term "HEAD PAIN" on row "1" to appear with Query status "closed"
  And I take a screenshot
  When in Coder, I Browse and Code Term "HEAD PAIN" on row 1, entering value "ASPIRING W/OXYCODONE" and selecting dictionary tree row 5 and "Create Synonym"
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I search for subject "Subject_you_created_from_sticky" for study named "RaveCoderSP<id>" and site "Active Site"
  And I open log line 1 for Coder datapoint "HEAD PAIN" on form "suppandcomp"
  Then I verify the following EDC fields data:
    |value                  |
    |ASPIRIN W/OXYCODONE    |
    |009533 01 001 4        |
  And I take a screenshot
  And I logout from "Rave"