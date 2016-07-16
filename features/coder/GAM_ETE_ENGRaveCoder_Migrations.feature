Feature: Test the full round trip integration from Rave to Coder back to Rave

@WIP
@PB1.1.2-007
@Release2011.1.0
@DT13577
Scenario: Verify verbatim autocodes to migrated synonym when study is moved to new dictionary version.
  Given I login to "imedidata" as user "rave_coder<id>"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I set coder and rave defaults with the following options:
    |Dictionary     |MedDRA              |
    |version        |11.0                |
    |locale         |ENG                 |
    |syn_list_name  |Primary             |
    |primary_path   |OFF                 |
    |project        |RaveCoderSP<id>     |
  And I navigate to "Forms" for Form "ETE7" in Draft "Draft 1" for Project "RaveCoderSP<id>"
  And I setup the field "CoderFieldETE7" to use dictionary "CODER- MedDRA"
  And I configure dictionary to use "LLT" as the coding level
  And I Publish and Push Draft "Draft 1" as "ETE7Draft<l>" in "Prod" environment to All sites
  And I add a subject for study "RaveCoderSP<id>" and site "Active Site" with following values:
    |label              |value          |
    |Subject Initials   |SETE7          |
    |Subject Number     |Mediflex<l>    |
  And I submit verbatim term "terrible head pain"  for form "ETE7"
  And I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And in Coder, I wait for 1 task to show up in the task page
  Then in Coder, I should see verbatim term "TERRIBLE HEAD PAIN" located in Coder Main Table
  And I take a screenshot
#  When I browse and code term "terrible head pain" to "head pain" using the following dictionary options:
  When in Coder, I Browse and Code Term "TERRIBLE HEAD PAIN" on row 1, entering value "BIOPSY SKIN" and selecting dictionary tree row 5 and "Create Synonym"
  And in Coder, I create a new Synonym List named "Secondary" using Dictionary "MedDRA", version "11.1" and  Locale "ENG"
  And in Coder, I upgrade newly created synonym list from Dictionary Version "11.0" and synonym list "Primary"
  And in Coder, I perform a study migration on Study "RaveCoderSP<id>" using following data:
    |Dictionary       |From Version  |From Syn List   |To Version  |To Syn List   |
    |MedDRA (ENG)     |11.0          |Primary         |11.1        |Secondary     |
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I add a subject for study "RaveCoderSP<id>" and site "Active Site" with following values:
    |label              |value          |
    |Subject Initials   |SETE7_1        |
  And I submit verbatim term "terrible head pain"  for form "ETE7"
  And I wait for value "Biopsy skin" to appear on form "ETE7" for coded term "TERRIBLE HEAD PAIN"
  Then I verify the following EDC fields data:
    |SOC                              |
    |Investigations                   |
    |10022891                         |
    |HLGT                             |
    |Skin investigations              |
    |10040879                         |
    |HLT                              |
    |Skin histopathology procedures   |
    |10040862                         |
    |PT                               |
    |Biopsy skin                      |
    |10004873                         |
  And I take a screenshot
  And I logout from "Rave"
