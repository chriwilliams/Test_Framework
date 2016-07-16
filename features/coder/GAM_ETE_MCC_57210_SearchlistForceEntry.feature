Feature: Verify using the search list by entering a value not in the options is fully supported and the around trip integration works successfully.

@WIP
@PBMCC57210-001b
@ReleaseRave2013.2.0
Scenario: A coding decision will be accepted by EDC for a verbatim that has supplemental data that is not part of the SearchList dropdown values.
  Given I login to "imedidata" as user "rave_coder<id>"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup18" from iMedidata
  And in Coder, I set coder defaults with the following options:
    | Dictionary     | MedDRA                 |
    | version        | 11.0                   |
    | locale         | ENG                    |
    | syn_list_name  | Primary                |
    | primary_path   | ON                     |
    | Synonym_Policy | Active                 |
    | project        | RaveCoderSP<id>        |
    | StudyGroup     | RaveCoderStudyGroup18  |
    | ConfigFile     | RaveDraft_Template.xls |
    | Draft          | Draft 1                |
  And in Coder, I activate and register dictionary "WhoDrugDDEB2" with the following options:
    | version       | 200703          |
    | locale        | ENG             |
    | syn_list_name | Primary         |
    | primary_path  | N/A             |
    | project       | RaveCoderSP<id> |
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I restore Rave defaults for project "RaveCoderSP<id>"
  And I navigate to "Forms" for Form "ETE17" in Draft "Draft 1" for Project "RaveCoderSP<id>"
  And I setup the field "Medical Term" to use dictionary "CODER- WhoDrugDDEB2"
  And I configure dictionary to use "PRODUCTSYNONYM" as the coding level
  And I select and save following supplemental fields:
    |Value                  |
    |ETEMCC40159SEARCHLIST  |
  And I Publish and Push Draft "Draft 1" as "Test Draft<l>" in "Prod" environment to All sites
  And I add a subject for study "RaveCoderSP<id>" and site "Active Site" with following values:
    |label              |Value       |
    |Subject Initials   |SETE17      |
    |Subject Number     |Mediflex<l> |
  And I submit verbatim term for the following field on "ETE1" form:
    | Field Name   | Type      | Value              |
    | Medical Term | long_text | TERRIBLE HEAD PAIN |
#  And I fill in form "ETE17" with the following values:
#    | Label        | Control Type           | Value           |
#    | Medical Term | Text Field             | Drug Verbatim 1 |
#    | ???????      | Search List Text Field | Company         |
  And I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And in Coder, I wait for 1 task to show up in the task page
  Then in Coder, I should see verbatim term "TERRIBLE HEAD PAIN" located in Coder Main Table
  And in Coder, I verify the following in Source Term tab for Supplements table:
    | Supplemental Term                 | Supplemental Value |
    | ETEMCC40159.ETEMCC40159SEARCHLIST | terrible head pain |
#  And I select table row "1" located in Coder Main Table and verify the following in "Supplements" table:
#    |Value		                         |
#    |ETEMCC40159.ETEMCC40159SEARCHLIST   |
#    |terrible head pain                  |
  And I take a screenshot
  When in Coder, I Browse and Code Term "TERRIBLE HEAD PAIN" on row 1, entering value "BAYER CHILDREN'S COLD" and selecting dictionary tree row 5 and "Do Not Create Synonym"
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I search for subject "Subject_you_created" for study named "RaveCoderSP<id>" and site "Active Site"
  And I open log line 1 for Coder datapoint "Drug Verbatim 1" on form "ETE17"
  And in Coder, I wait for value "Bayer Children's Cold" to appear on form "ETE17" for coded term "Drug Verbatim 1"
  Then I verify the following EDC fields data:
    |BAYER CHILDREN'S COLD   |
    |005581 01 001 3         |
  And I take a screenshot
  And I logout from "Rave"
