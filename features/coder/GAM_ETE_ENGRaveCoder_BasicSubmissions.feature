Feature: Test the basic full round trip integration from Rave to Coder back to Rave


@VAL
@PB1.1.2-001
@Release2011.1.0
Scenario: Enter project registration in Coder, setup Rave study, enter verbatim in Rave, code verbatim in Coder, and see results in Rave
  Given I login to "imedidata" as user "rave_coder19"
  And I set coder and rave defaults with the following options:
    | Dictionary              | MedDRA                 |
    | version                 | 11.0                   |
    | locale                  | ENG                    |
    | syn_list_name           | Primary                |
    | primary_path            | ON                     |
    | synonym_creation_policy | Active                 |
    | project                 | RaveCoderSP18          |
    | StudyGroup              | RaveCoderStudyGroup18  |
    | ConfigFile              | RaveDraft_Template.xls |
    | Draft                   | Draft 1                |
  And I navigate to "Forms" for Form "ETE1" in Draft "Draft 1" for Project "RaveCoderSP18"
  And I setup the field "Coder Term 1" to use dictionary "CODER- MedDRA"
  And I configure dictionary to use "LLT" as the coding level
  And I Publish and Push Draft "Draft 1" as "ETE11Draft<l>" in "Prod" environment to All sites
  #TODO
  When I am on add subject page for project "RaveCoderSP<i2>" in RaveX
  #endofTODO
  And I add a subject in RaveX with the following data:
    | Field Name       | Type | Value       |
    | Subject Initials | text | SETE1       |
    | Subject Number   | text | Mediflex<l> |
  And I enter the following data for the "ETE1" form:
    | Field Name   | Type | Value               |
    | Coder Term 1 | text | SHARP PAIN DOWN LEG |
  #TODO
  # Note: there is no code coverage for RaveX navigation
  And I navigate to iMedidata from "RaveX"
  # endofTodo
  And I navigate to "Coder" for study group "RaveCoderStudyGroup18" from iMedidata
  And I wait for "1" tasks to show up in the task page
  Then I should see verbatim term "TERRIBLE HEAD PAIN" located in Coder Main Table
  And I take a screenshot
  And I Browse and Code Term "JOINT PAIN" on row 1, entering value "bayer" and selecting dictionary tree row 5 and "Create Synonym"
  And I navigate to iMedidata from "Coder"
  And I navigate to "RaveX" for study group "RaveCoderStudyGroup18" from iMedidata
  #TODO
  # need steps to navigate to project inside RaveX
  And I search for subject "Subject_you_created" in RaveX
  And I search for subject "Subject_you_created" in RaveX for study named "RaveCoderSP18" and site "Active Site"
  #endofTODO
  And I open log line "1" for Coder datapoint "TERRIBLE HEAD PAIN" on form "ETE1"
  #TODO
  Then I verify the following RaveX fields data:
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
  #endofTODO
  And I take a screenshot
  And I logout from "RaveX"

@VAL
@PB1.1.2-002
@Release2011.1.0
Scenario: Enter project registration in Coder, setup Rave study with component and supplemental fields, enter verbatim in Rave, reject verbatim in Coder, verify component and supplemental data appears in Coder, and see results in Rave
  Given I login to "iMedidata" as user "coderuser<id>"
  And I set coder and rave defaults with the following options:
    |Dictionary                 |WhoDrugDDEB2              |
    |version                    |200703                    |
    |locale                     |ENG                       |
    |syn_list_name              |Primary                   |
    |primary_path               |ON                        |
    |synonym_creation_policy    |Active                    |
    |project                    |RaveCoderSP<id>           |
    |StudyGroup                 |RaveCoderStudyGroup<id>   |
    |ConfigFile                 |RaveDraft_Template.xls    |
    |Draft                      |Draft 1                   |
  And I navigate to "Forms" for Form "ETE2" in Draft "Draft 1" for Project "RaveCoderInvETEProject<id>"
  And I setup the field "CoderField2" to use dictionary "CODER- WhoDrugDDEB2"
  And I configure dictionary to use "PRODUCTSYNONYM" as the coding level
  And I select and save following supplemental fields:
    |LOGSUPPFIELD2    |
    |LOGSUPPFIELD4    |
  And I select and save following component fields:
    |Field        |Value  |
    |LOGCOMPFIELD1|COMPANY|
    |LOGCOMPFIELD3|SOURCE |
  And I Publish and Push Draft "Draft 1" as "ETE2<l>" in "Prod" environment to All sites
  And I add a subject for study "RaveCoderStudyGroup<id>" and site "Active Site" with following values:
    | Field Name       | Type        | Value       |
    | Subject Initials | text        | SETE1       |
    | Subject Number   | text        | Mediflex<l> |
  And I enter the following data for the "ETE2" Rave form:
    | Field Name       | Type      | Value               |
    | Coder Field 2    | long_text | SHARP PAIN DOWN LEG |
    | Log Comp Field 1 | text      | 33                  |
    | Log Supp Field1  | long_text | New Jersey          |
    | Std Comp Field   | long_text | United States       |
    | Std Supp Field 4 | long_text | Lost in Translation |
  And I save Rave EDC form
  And I add a Log Line in Rave EDC
  And I enter the following data for the "ETE2" Rave form:
    | Field Name       | Type      | Value                |
    | Coder Field 2    | long_text | SHARP PAIN IN NERVES |
    | Log Comp Field 1 | text      | 22                   |
    | Log Supp Field1  | long_text | NEW YORK             |
  And I save Rave EDC form
  When I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  Then I wait for "2" tasks to show up in the task page
  And I should see verbatim term "SHARP PAIN DOWN LEG" located in Coder Main Table
  And I should see verbatim term "SHARP PAIN IN NERVES" located in Coder Main Table
  And I take a screenshot
  When I select term "SHARP PAIN DOWN LEG" in Coder Main Table on row "1"
  And I verify the following in Source Term tab for Supplements table:
    |Supplements Term     |Supplements Value     |
    |ETE2.LOGSUPPFIELD2   |New Jersey            |
    |ETE2.LOGSUPPFIELD4   |lost in translation   |
  And I verify the following data in Reference Table:
    | Name    | Value        |
    | Field   | CODERFIELD2  |
    | Line    | 1            |
    | Form    | ETE2         |
    | Event   | SUBJECT      |
    | Subject | sub_name     |
    | Site    | Active Site  |
  And I take a screenshot
  When I open a query with query text "test query" for term "HEAD PAIN" on row "1"
  And I Browse and Code Term "SHARP PAIN IN NERVES" on row 1, entering value "BAYER CHILDREN'S COUGH" and selecting dictionary tree row 6 and "Create Synonym"
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup3" from iMedidata
  And I search for subject "coder_subj_timestamp_139" for study named "rave_coder_ete_study" and site "site name"
  And I open log line "1" for Coder datapoint "SHARP PAIN DOWN LEG" on form "ETE2"
  Then I verify icon Query Open displayed for field "SHARP PAIN DOWN LEG" on Rave form
  Then I verify query text "Rejecting Decision due to bad term" is displayed for the field "SHARP PAIN DOWN LEG" on Rave form
  And I take a screenshot
  When I open log line "2" for Coder datapoint "SHARP PAIN IN NERVES" on form "ETE2"
  Then I verify the following EDC fields data:
    |ATC                                                |
    |RESPIRATORY SYSTEM                                 |
    |R                                                  |
    |ATC                                                |
    |COUGH AND COLD PREPARATIONS                        |
    |R05                                                |
    |ATC                                                |
    |COUGH SUPPRESSANTS EXCL. COMB. WITH EXPECTORANTS   |
    |R05D                                               |
    |ATC                                                |
    |OPIUM ALKALOIDS AND DERIVATIVES                    |
    |R05DA                                              |
    |PRODUCT                                            |
    |BAYER CHILDREN'S COUGH                             |
    |007574 01 001 8                                    |
  And I logout from "Rave"
