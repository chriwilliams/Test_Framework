Feature: Test the full round trip integration from Rave to Coder back to Rave for Japanese

@WIP
@PB1.1.2-003J
@Release2012.1.0
Scenario: Code an updated verbatim in Coder and verify the coding decision for the updated term is displayed in EDC.
  Given I login to "imedidata" as user "rave_coder<id>"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup18" from iMedidata
  And I set coder and rave defaults with the following options:
    |Dictionary     |MedDRA              |
    |version        |11.0                |
    |locale         |JPN                 |
    |syn_list_name  |Primary             |
    |primary_path   |ON                  |
    |Synonym_Policy |Active              |
    |project        |RaveCoderSP<id>     |
  And I navigate to "Forms" for Form "ETE3" in Draft "Draft 1" for Project "RaveCoderSP<id>"
  And I setup the field "CoderFieldETE3" to use dictionary "CODER- MedDRA"
  And I configure dictionary to use "LLT" as the coding level
  And I select Project tab in Rave
  And I Publish and Push Draft "Draft 1" as "ETE3JDraft<l>" in "Prod" environment to All sites
  When I add a subject for study "RaveCoderSP<id>" and site "Active Site" with following values:
    |label              |value          |
    |Subject Initials   |SETE3J         |
    |Subject Number     |Mediflex<l>    |
  And I submit verbatim term for the following field on "ETE3" form:
    | Field Name        | Type      | Value     |
    | Coder Field ETE 3 | long_text | ひどい頭痛 |
  And I resubmit verbatim term for the following field on "ETE3" form:
    | Field Name        | Type      | Value     |
    | Coder Field ETE 3 | long_text | ひどい頭痛 |
#  And I resubmit verbatim term "左脚の足の痛み" for form "ETE3"
  And I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And in Coder, I wait for 1 task to show up in the task page
  Then in Coder, I should see verbatim term "左脚の足の痛み" located in Coder Main Table
  And I take a screenshot
  When in Coder, I Browse and Code Term "左脚の足の痛み" on row 1, entering value "片側頭痛" and selecting dictionary tree row 5 and "Create Synonym"
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I search for subject "Subject_you_created" for study named "RaveCoderSP<id>" and site "Active Site"
  And I open log line 1 for Coder datapoint "TERRIBLE HEAD PAIN" on form "ETE1"
  And I wait for value "Complicated migraine" to appear on form "ETE12" for coded term "Headache 1"
  Then I verify the following EDC fields data:
    |SOC           |
    |神経系障害     |
    |10029205      |
    |HLGT          |
    |頭痛          |
    |10019231      |
    |HLT           |
    |頭痛ＮＥＣ     |
    |10019233      |
    |PT            |
    |片側頭痛       |
    |10067040      |
  And I take a screenshot
  And I logout from "Rave"
