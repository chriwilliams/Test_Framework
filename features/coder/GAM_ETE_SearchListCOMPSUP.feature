Feature: Verify using Search List combinations of standard fields, log line fields, search list, etc. for coding fields & supplement and component values is fully supported and the around trip integration works successfully.


#  The following scenario is a combination of these scenarios:
#  PB92926DSL-003COMPSUP
#  PB92926DSL-006LLCOMPSUP
#  PB92926SL-008

@WIP
@PB92926SL-004
@Release2014.1.0
Scenario: Standard and log line verbatim and supplemental fields using Dynamic Search List or Search List will be coded successfully.
  Given I login to "imedidata" as user "rave_coder<id>"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup18" from iMedidata
  And I set coder and rave defaults with the following options:
    | Dictionary    | MedDRA                  |
    | version       | 11.0                    |
    | locale        | ENG                     |
    | syn_list_name | Primary                 |
    | primary_path  | OFF                     |
    | project       | RaveCoderSP<id>         |
    | StudyGroup    | RaveCoderStudyGroup<id> |
  And I activate and register dictionary "WhoDrugDDEB2" with the following options:
    | version       | 200703          |
    | locale        | ENG             |
    | syn_list_name | Primary         |
    | primary_path  | N/A             |
    | project       | RaveCoderSP<id> |
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I restore Rave defaults for project "RaveCoderSP<id>"
  And I navigate to "Forms" for Form "ETE19" in Draft "Draft 1" for Project "RaveCoderSP<id>"
  And I setup the field "Std SL Coding Field" to use dictionary "CODER- WhoDrugDDEB2"
  And I choose "WhoDrug Verbatims" as dictionary option for Coding Dictionary "CODER- WhoDrugDDEB2"
  And I configure dictionary to use "PRODUCTSYNONYM" as the coding level
  And I select and save following supplemental fields:
    | Value            |
    | STDSEARCHLISTSUP |
  And I setup the field "LLSLSUP" to use dictionary "CODER- WhoDrugDDEB2"
  And I configure dictionary to use "PRODUCTSYNONYM" as the coding level
  And I select and save following supplemental fields:
    |Value    |
    |LLSLSUP  |
  And I Publish and Push Draft "Draft 1" as "Test Draft<l>" in "Prod" environment to All sites
  And I add a subject for study "RaveCoderSP<id>" and site "Active Site" with following values:
    | label            | Value       |
    | Subject Initials | SETE19      |
    | Subject Number   | Mediflex<l> |
  And I fill in form "ETE19" with the following values:
    | Label               | Control Type           | Value                 |
    | Std Coding Field    | Dynamic Search List    | Induced Pain Reliever |
    | Std SL Coding Field | Drop-down              | Company               |
    | Need to Look up     | Search List Text Field | Child Advil Cold      |
    | Need to Look up     | Searh List Text Field  | Yes                   |
  And I add another Log line for form "ETE19"
  And I fill in form "ETE19" with the following values:
    | Label           | Control Type           | Value   |
    | Need to Look Up | Search List Text Field | Smoking |
    | Need to Look Up | Search List Text Field | No      |
  And I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And in Coder, I wait for 2 tasks to show up in the task page
  Then in Coder, I should see verbatim term "TERRIBLE HEAD PAIN" located in Coder Main Table
  And I take a screenshot
  When in Coder, I verify the following in Source Term tab for Supplements table:
  |Supplemental Term|Supplemental Value|
  |ETE19.STDSEARCHLISTSUP|Yes          |                    |
  And I take a screenshot
  When in Coder, I Browse and Code Term "TERRIBLE HEAD PAIN" on row 1, entering value "HEAD PAIN" and selecting dictionary tree row 5 and "Do Not Create Synonym"
  And in Coder, I Browse and Code Term "2nd TERRIBLE HAED PAIN" on row 1, entering value "HEAD PAIN" and selecting dictionary tree row 5 and "Do Not Create Synonym"
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I search for subject "Subject_you_created" for study named "RaveCoderSP<id>" and site "Active Site"
  And I open log line 1 for Coder datapoint "TERRIBLE HEAD PAIN" on form "ETE19"
  Then I verify the following EDC fields data:
    | advil cold           |
    | 010502 01 022 5      |
    | CHILDRENS ADVIL COLD |
    | 010502 01 015 9      |
  And I take a screenshot
  And I logout from "Rave"
