Feature: Test the basic full round trip integration from RaveX to Coder back to RaveX


  @VAL
  @PB1.1.2-001
  @Release2011.1.0
  Scenario: Enter project registration in Coder, setup Rave study, enter verbatim in RaveX, code verbatim in Coder, and see results in RaveX
    Given in "Coder" I have configurable data set from the following:
      | UserName   | user_name    |
      | Project    | project_name |
      | StudyGroup | study_group  |
    And I login to "imedidata" as user "user_name"
    And I set coder and rave defaults with the following options:
      | Dictionary              | MedDRA                 |
      | version                 | 11.0                   |
      | locale                  | ENG                    |
      | syn_list_name           | Primary                |
      | primary_path            | ON                     |
      | synonym_creation_policy | Active                 |
      | project                 | project_name           |
      | StudyGroup              | study_group            |
      | ConfigFile              | RaveDraft_Template.xls |
      | Draft                   | Draft 1                |
    And I navigate to "Forms" for Form "ETE1" in Draft "Draft 1" for Project "project_name"
    And I setup the field "Coder Term 1" to use dictionary "CODER- MedDRA"
    And I configure dictionary to use "LLT" as the coding level
    And I Publish and Push Draft "Draft 1" as "ETE11Draft<l>" in "Prod" environment to All sites
    And I navigate to iMedidata from "rave"
    And In iMedidata I navigate to "RaveX" for study group "study_group"
    When I am on add subject page for study "project_name"
    And I add a subject in Rave with the following data:
      | Field Name       | Type | Value       |
      | Subject Initials | text | SETE1       |
      | Subject Number   | text | Mediflex<l> |
    And I submit verbatim term for the following field on "ETE1" form:
      | Field Name   | Type      | Value              |
      | Coder Term 1 | long_text | TERRIBLE HEAD PAIN |
    And I navigate to iMedidata from "RaveX"
    And In iMedidata I navigate to "Coder" for study group "study_group"
    And in Coder I wait for 1 task to show up in the task page
    Then in Coder I should see verbatim term "TERRIBLE HEAD PAIN" located in Coder Main Table
    And I take a screenshot
    And in Coder I Browse and Code Term "TERRIBLE HEAD PAIN" on row 1, entering value "HEAD" and selecting dictionary tree row 5 and "Create Synonym"
    And I navigate to iMedidata from "Coder"
    And In iMedidata I navigate to "RaveX" for study group "study_group"
    And I search for subject "Subject_you_created" for study named "project_name" and site "Active Site"
    And I open Coder form "ETE1"
    And I open log line 1 for Coder datapoint "TERRIBLE HEAD PAIN" on form "ETE1"
    Then I verify the following EDC fields data:
      | TERRIBLE HEAD PAIN                                   |
      | SOC                                                  |
      | General disorders and administration site conditions |
      | 10018065                                             |
      | HLGT                                                 |
      | General system disorders NEC                         |
      | 10018073                                             |
      | HLT                                                  |
      | General signs and symptoms NEC                       |
      | 10018072                                             |
      | LLT                                                  |
      | 10017566                                             |
      | Fuzzy head                                           |
    And I take a screenshot
    And I logout from "RaveX"

  @VAL
  @PB1.1.2-002
  @Release2011.1.0
  Scenario: Enter project registration in Coder, setup Rave study with component and supplemental fields, enter verbatim in RaveX, reject verbatim in Coder, verify component and supplemental data appears in Coder, and see results in RaveX
    Given in "Coder" I have configurable data set from the following:
      | UserName   | user_name    |
      | Project    | project_name |
      | StudyGroup | study_group  |
    And I login to "iMedidata" as user "user_name"
    And I set coder and rave defaults with the following options:
      | Dictionary              | WhoDrugDDEB2           |
      | version                 | 200703                 |
      | locale                  | ENG                    |
      | syn_list_name           | Primary                |
      | primary_path            | ON                     |
      | synonym_creation_policy | Active                 |
      | project                 | project_name           |
      | StudyGroup              | study_group            |
      | ConfigFile              | RaveDraft_Template.xls |
      | Draft                   | Draft 1                |
    And I navigate to "Forms" for Form "ETE2" in Draft "Draft 1" for Project "project_name"
    And I setup the field "CoderField2" to use dictionary "CODER- WhoDrugDDEB2"
    And I configure dictionary to use "PRODUCTSYNONYM" as the coding level
    And I select and save following supplemental fields:
      | LOGSUPPFIELD2 |
      | LOGSUPPFIELD4 |
    And I select and save following component fields:
      | Field         | Value   |
      | LOGCOMPFIELD1 | COMPANY |
      | LOGCOMPFIELD3 | SOURCE  |
    And I Publish and Push Draft "Draft 1" as "ETE2<l>" in "Prod" environment to All sites
    And I navigate to iMedidata from "rave"
    And In iMedidata I navigate to "RaveX" for study group "study_group"
    When I am on add subject page for study "project_name"
    And I add a subject in RaveX with the following data:
      | Field Name       | Type | Value       |
      | Subject Initials | text | SETE1       |
      | Subject Number   | text | Mediflex<l> |
    And I submit verbatim term for the following field on "ETE2" form:
      | Field Name       | Type      | Value               |
      | Coder Field 2    | long_text | SHARP PAIN DOWN LEG |
      | Log Comp Field 1 | text      | 33                  |
      | Log Supp Field1  | text      | New Jersey          |
      | Std Comp Field 3 | text      | United States       |
      | Std Supp Field 4 | text      | Lost in Translation |
    And I save RaveX EDC form
    And I add a Log Line in RaveX EDC
    And I enter the following data for the "ETE2" form:
      | Field Name       | Type      | Value                |
      | Coder Field 2    | long_text | SHARP PAIN IN NERVES |
      | Log Comp Field 1 | text      | 22                   |
      | Log Supp Field1  | text      | NEW YORK             |
    And I save RaveX EDC form
    When I navigate to iMedidata from "RaveX"
    And In iMedidata I navigate to "Coder" for study group "study_group"
    And in Coder I wait for 2 tasks to show up in the task page
    And in Coder I should see verbatim term "SHARP PAIN DOWN LEG" located in Coder Main Table
    And in Coder I should see verbatim term "SHARP PAIN IN NERVES" located in Coder Main Table
    And I take a screenshot
    When in Coder I select term "SHARP PAIN DOWN LEG" in Coder Main Table on row "1"
    And in Coder I verify the following in Source Term tab for Supplements table:
      | Supplemental Term  | Supplemental Value  |
      | ETE2.LOGSUPPFIELD2 | New Jersey          |
      | ETE2.LOGSUPPFIELD4 | Lost in Translation |
    And in Coder I verify the following data in Reference Table:
      | Name    | Value       |
      | Field   | CODERFIELD2 |
      | Line    | 1           |
      | Form    | ETE2        |
      | Event   | SUBJECT     |
      | Subject | sub_name    |
      | Site    | Active Site |
    And I take a screenshot
    When in Coder I open a query with query text "Rejecting Decision due to bad term" for term "SHARP PAIN DOWN LEG" on row 1
    And in Coder I Browse and Code Term "SHARP PAIN IN NERVES" on row 2, entering value "BAYER CHILDREN'S COUGH" and selecting dictionary tree row 6 and "Create Synonym"
    And I navigate to iMedidata from "Coder"
    And In iMedidata I navigate to "RaveX" for study group "study_group"
    And I search for subject "subject_you_created" for study named "project_name" and site "site name"
    And I open log line 1 for Coder datapoint "SHARP PAIN DOWN LEG" on form "ETE2"
    Then I verify icon Query Open displayed for field "SHARP PAIN DOWN LEG" on RaveX form
    Then I verify query text "Rejecting Decision due to bad term" is displayed for the field "SHARP PAIN DOWN LEG" on RaveX form
    And I take a screenshot
    And in RaveX I wait for the coded term and id to appear on Coder datapoint "SHARP PAIN IN NERVES" on form "ETE2" for log line 2:
      | BAYER CHILDREN'S COUGH |
      | 007574 01 001 8        |
    Then I verify the following EDC fields data:
      | ATC                                              |
      | RESPIRATORY SYSTEM                               |
      | R                                                |
      | ATC                                              |
      | COUGH AND COLD PREPARATIONS                      |
      | R05                                              |
      | ATC                                              |
      | COUGH SUPPRESSANTS EXCL. COMB. WITH EXPECTORANTS |
      | R05D                                             |
      | ATC                                              |
      | OPIUM ALKALOIDS AND DERIVATIVES                  |
      | R05DA                                            |
      | PRODUCT                                          |
    And I logout from "RaveX"
