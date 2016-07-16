Feature: Test the basic full round trip integration from Rave to Coder back to Rave


# The following scenario is a combination of
# PB1.1.2-019      ## primary path unchecked
# PB1.1.2-023      ## primary path unchecked
# PBMCC52852-003   ## primary path checked


## use form ETE2 instead of ETE15
@WIP
@PB1.1.2-019_23
@ReleasePatch08
@DT13771
Scenario: Verify that submitting multiple log lines for mixed and non-mixed forms in Rave will all get sent to Coder
  Given I login to "imedidata" as user "rave_coder<id>"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I set coder and rave defaults with the following options:
    |Dictionary     |MedDRA              |
    |version        |11.0                |
    |locale         |ENG                 |
    |syn_list_name  |Primary             |
    |primary_path   |ON                  |
    |Synonym_Policy |Active              |
    |project        |RaveCoderSP<id>     |
  And I navigate to "Forms" for Form "ETE12" in Draft "Draft 1" for Project "RaveCoderSP<id>"
  And I setup the field "ETE12" to use dictionary "CODER- WhoDrugDDEB2"
  And I configure dictionary to use "PRODUCTSYNONYM" as the coding level
  And I navigate to "Forms" for Form "ETE2" in Draft "Draft 1" for Project "RaveCoderSP<id>"
  And I setup the field "CoderField2" to use dictionary "CODER- WhoDrugDDEB2"
  And I configure dictionary to use "PRODUCTSYNONYM" as the coding level
  And I Publish and Push Draft "Draft 1" as "ETE1215Draft<l>" in "Prod" environment to All sites
  When I add a subject for study "RaveCoderSP<id>" and site "Active Site" with following values:
    |label              |value          |
    |Subject Initials   |SETE_2_12      |
    |Subject Number     |Mediflex<l>    |
  And I submit verbatim term "Headache 1"  for form "ETE12"
  And I add another log line and submit term "Headache 2" for form "ETE12"
  And I add another log line and submit term "Headache 3" for form "ETE12"
  And I add another log line and submit term "Headache 4" for form "ETE12"
  And I submit verbatim term "Migraine 1"  for form "ETE2"
  And I add another log line and submit term "Migraine 1" for form "ETE2"
  And I add another log line and submit term "Migraine 2" for form "ETE2"
  And I add another log line and submit term "Migraine 3" for form "ETE2"
  And I add another log line and submit term "Migraine 4" for form "ETE2"
  And I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And in Coder, I wait for 8 tasks to show up in the task page
  Then in Coder, I expect to see the following verbatim terms in Coder Main Table
    |Term         |
    |Headache 1   |
    |Headache 2   |
    |Headache 3   |
    |Headache 4   |
    |Migraine 1   |
    |Migraine 2   |
    |Migraine 3   |
    |Migraine 4   |
  And I take a screenshot
  When in Coder, I Browse and Code Term "HEADACHE 1" on row 1, entering value "COMPLICATED MIGRAIN" and selecting dictionary tree row 5 and "DO NOT CREATE A SYNONYM"
  And in Coder, I Browse and Code Term "HEADACHE 2" on row 1, entering value "COMPLICATED MIGRAINE" and selecting dictionary tree row 5 and "DO NOT CREATE A SYNONYM"
  And in Coder, I Browse and Code Term "MIGRAINE 2" on row 1, entering value "MIGRAINE" and selecting dictionary tree row 6 and "DO NOT CREATE A SYNONYM"
  And in Coder, I Browse and Code Term "MIGRAINE 2" on row 4, entering value "MIGRAINE" and selecting dictionary tree row 7 and "DO NOT CREATE A SYNONYM"
  When in Coder, I open a query with query text "test query" for term "HEADACHE 3" on row 1
  And in Coder, I open a query with query text "test query" for term "Migrain 3" on row 3
  Then in Coder, I expect to see the following verbatim terms in Coder Main Table
    |Term         |
    |Headache 1   |
    |Headache 2   |
  And I take a screenshot
  When I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I search for subject "Subject_you_created" for study named "RaveCoderSP<id>" and site "Active Site"
  And I open log line 1 for Coder datapoint "HEADACHE 1" on form "ETE12"
  And I wait for value "Complicated migraine" to appear on form "ETE12" for coded term "Headache 1"
  And I wait for value "Rejecting Decision due to bad term" to appear on form "ETE12" for coded term "Headache 2"
  When I expand form "ETE12"
  Then I expect to see the following icons:
    |image                        |
    |Rave Check Icon              |
    |Rave Check Icon              |
    |Rave Query Icon              |
    |Medidata Coder Coding Icon   |
    |Medidata Coder Coding Icon   |
  And I take a screenshot
  When I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And in Coder, I clean coder app with a "Data Clear"
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I search for subject "Subject_you_created" for study named "RaveCoderSP<id>" and site "Active Site"
  And I add another log line for form "ETE12"
  And I submit verbatim term "HEADACHE INFINITE"  for form "ETE12"
  And I navigate to iMedidata from "Rave"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And in Coder, I wait for 1 task to show up in the task page
  Then in Coder, I should see verbatim term "HEADACHE INFINITE" located in Coder Main Table
  And in Coder, I verify the following terms does not exist in Coder Main Table:
    |Term       |
    |Headache 1 |
    |Headache 2 |
    |Headache 3 |
    |Headache 4 |
    |Headache 5 |
  And I logout from "Coder"
