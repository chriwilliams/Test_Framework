Feature: Verify using the "Other Specify" for drop-downs and search-lists is supported and the around trip integration works successfully.


@WIP
@PBMCC40159-001b
@ReleaseRave2013.2.0
@DTMCC68955
Scenario: A coding decision will be accepted by EDC for a verbatim whose supplemental field is using the "Other Specify" dropdown option.
  Given I login to "imedidata" as user "rave_coder<id>"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I set coder and rave defaults with the following options:
    |Dictionary     |MedDRA              |
    |version        |11.0                |
    |locale         |ENG                 |
    |syn_list_name  |Primary             |
    |primary_path   |OFF                 |
    |Synonym_Policy |Active              |
    |project        |RaveCoderSP<id>     |
  And I navigate to "Forms" for Form "ETE17" in Draft "Draft 1" for Project "RaveCoderSP<id>"
  And I setup the field "Medical Term" to use dictionary "CODER- WhoDrugDDEB2"
  And I select and save following supplemental fields:
    |ETEMCC40159DROPDOWN    |
  And I select Project tab in Rave
  And I Publish and Push Draft "Draft 1" as "ETE17Draft<l>" in "Prod" environment to All sites
  And I add a subject for study "RaveCoderSP<id>" and site "Active Site" with following values:
    |label              |value          |
    |Subject Initials   |SETE17         |
    |Subject Number     |Mediflex<l>    |
  And I submit verbatim term for the following field on "ETE17" form:
    | Field Name   | Type      | Value           |
    | Medical Term | long_text | Drug Verbatim 1 |
    | ON           | Radio     | Specify Radio   |
#  And I submit a verbatim term "Drug Verbatim 1" with "Other Options" selected from "some-drop-down" for from "ETE17"
  And I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And in Coder, I wait for 1 tasks to show up in the task page
  Then in Coder, I should see verbatim term "Drug Verbatim 1" located in Coder Main Table
  And I take a screenshot
  When in Coder, I verify the following in Source Term tab for Supplements table:
    | Supplemental Term               | Supplemental Value |
    | ETEMCC40159.ETEMCC40159DROPDOWN | Drug Verbatim 1    |
  And I take a screenshot
  When in Coder, I Browse and Code Term "Drug Verbatim 1" on row 1, entering value "BAYER CHILDREN'S COLD" and selecting dictionary tree row 5 and "Do Not Create Synonym"
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I search for subject "Subject_you_created" for study named "RaveCoderSP<id>" and site "Active Site"
  And I open log line 1 for Coder datapoint "Drug Verbatim 1" on form "ETE17"
  And I wait for value "Complicated migraine" to appear on form "ETE12" for coded term "Drug Verbatim 1"
  Then I verify the following EDC fields data:
    |value                   |
    |BAYER CHILDREN'S COLD   |
    |005581 01 001 3         |
  And I take a screenshot
  And I logout from "Rave"
