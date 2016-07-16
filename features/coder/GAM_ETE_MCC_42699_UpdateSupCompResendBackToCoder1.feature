Feature: When supplemental and / or component terms are edited and updated, the verbatim term with updated information is sent back to Coder.

@WIP
@PBMCC42699-006
@Release2013.1.0
@VY16.JAN.2013
@VER2013.1.0
Scenario: Updating a log line supplemental field will cause the log line verbatim in EDC to be resent to Coder.
  Given I login to "imedidata" as user "rave_coder<id>"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And in Coder, I set coder defaults with the following options:
    |Dictionary     |WhoDrugDDEB2        |
    |version        |200703              |
    |locale         |ENG                 |
    |syn_list_name  |Primary             |
    |primary_path   |OFF                 |
    |Synonym_Policy |Active              |
    |project        |RaveCoderSP<id>     |
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I upload draft "MCC42699.xls"
#  And I upload Rave file "MCC42699.xls" with draft name "MCC42699" to project "<RaveCoderInvETEProjectB>"
  And I navigate to "Forms" for Form "suppandcomp" in Draft "MCC42699" for Project "RaveCoderSP<id>"
  And I setup the field "suppandcomp" to use dictionary "CODER- WhoDrugDDEB2"
  And I configure dictionary to use "Product" as the coding level
  And I select and save following supplemental fields:
    |Value|
    |SUPP |
  And I select Project tab in Rave
  And I select Draft "MCC42699"
  And I Publish and Push Draft "MCC42699" as "MCC42699<l>" in "Prod" environment to All sites
  And I add a subject for study "RaveCoderSP<id>" and site "Active Site" with following values:
    |label              |value          |
    |Subject Initials   |suppandcomp    |
    |Subject Number     |Mediflex<l>    |
#  And I submit verbatim term "HEAD PAIN" with supp value of "SUPP1" on form "suppandcomp"
  And I submit verbatim term for the following field on "ETE1" form:
    | Field Name  | Type      | Value     |
    | suppandcomp | long_text | HEAD PAIN |
  And I verify icon Requires Coding displayed for field "suppandcomp" on Rave form
#  And I expect to see "Medidata Coder Coding Icon"
  And I take a screenshot
  And I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And in Coder, I wait for 1 task to show up in the task page
  Then in Coder, I should see verbatim term "HEAD PAIN" located in Coder Main Table
  And I take a screenshot
  And in Coder, I verify the following in Source Term tab for Supplements table:
    | Supplemental Term | Supplemental Value |
    | MCC42699.SUPP     | Supp1              |
  And I take a screenshot
  And in Coder, I Browse and Code Term "HEAD PAIN" on row 1, entering value "BAYER CHILDREN'S COLD" and selecting dictionary tree row 5 and "Create Synonym"
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I search for subject "Subject_you_created" for study named "RaveCoderSP<id>" and site "Active Site"
  And I open log line 1 for Coder datapoint "TERRIBLE HEAD PAIN" on form "ETE1"
  Then I verify the following EDC fields data:
    |value                      |
    |BAYER CHILDREN'S COLD      |
    |005581 01 001 3            |
#  And I verify icon Requires Verification|Requires Review|Query Open|Answered Query|Requires Coding|Requires Signature) displayed for field "need to put field name here" on Rave form
  And I verify icon Complete displayed for field "<string>"
  And I take a screenshot
  And I resubmit verbatim term for the following field on "ETE1" form:
    | Field Name  | Type      | Value     |
    | suppandcomp | long_text | HEAD PAIN |
#  And I expect to see "1" Rave Check Image
  And I verify icon Requires Coding displayed for field "put field name here" on Rave form
  And I take a screenshot
  And I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And in Coder, I wait for 1 task to show up in the task page
  Then in Coder, I should see verbatim term "HEAD PAIN" located in Coder Main Table
  And I take a screenshot
  When in Coder, I verify the following in Source Term tab for Supplements table:
    | Supplemental Term | Supplemental Value |
    | MCC42699.SUPP     | Supp2              |
  And I take a screenshot
  When in Coder, I Browse and Code Term "head pain" on row 1, entering value "ASPIRIN W/OXYCODONE" and selecting dictionary tree row 5 and "Do not create synonym"
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I search for subject "Subject_you_created" for study named "RaveCoderSP<id>" and site "Active Site"
  And I open log line 1 for Coder datapoint "TERRIBLE HEAD PAIN" on form "ETE1"
  Then I verify the following EDC fields data:
    |value                      |
    |ASPIRIN W/OXYCODONE        |
    |009533 01 001 4            |
#  And I expect to see "1" Rave Check Image
  And I verify icon Complete displayed for field "put form name here" on Rave form
  And I take a screenshot
  And I logout from "Rave"
