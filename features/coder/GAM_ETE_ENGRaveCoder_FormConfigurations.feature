Feature: Test the full round trip integration from Rave to Coder back to Rave


@WIP
@PB1.1.2-017
@ReleasePatch08
@DT13639
Scenario: Test that Edit checks and derivations both fire when a coding response is sent back to Rave from Coder
  Given I login to "imedidata" as user "rave_coder<id>"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I set coder and rave defaults with the following options:
    |Dictionary     |MedDRA              |
    |version        |11.0                |
    |locale         |ENG                 |
    |syn_list_name  |Primary             |
    |primary_path   |OFF                 |
    |project        |RaveCoderSP<id>     |
  And I navigate to "Forms" for Form "ETE11" in Draft "Draft 1" for Project "RaveCoderSP<id>"
  And I setup the field "AETERM" to use dictionary "CODER- MedDRA"
  And I configure dictionary to use "LLT" as the coding level
  And I Publish and Push Draft "Draft 1" as "ETE11Draft<l>" in "Prod" environment to All sites
  And I add a subject for study "RaveCoderSP<id>" and site "Active Site" with following values:
    |label              |value          |
    |Subject Initials   |SETE11         |
    |Subject Number     |Mediflex<l>    |
  When I submit verbatim term "Headache"  for form "ETE11"
  And I store current timestamp to key "BeforeCodingTimeStamp" from Rave Log Table
  And I store test timestamp to key "TestTimeStampBeforeCoding" from Rave Log Table
  Then I verify the following EDC fields data:
    |Headache                   |
  And I take a screenshot
  When I open log line 1 for Coder datapoint "Headache" on form "ETE11"
  And I wait for value "Nervous system disorders" to appear on form "ETE11" for coded term "HEADACHE"
  Then I verify the following EDC fields data:
    |Headache                   |
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
  And I verify the "current timestamp" is the same as "BeforeCodingTimeStamp"
  And I verify the test timestamp is greater than the "TestTimeStampBeforeCoding"
  And I take a screenshot
  And I logout from "Rave"
