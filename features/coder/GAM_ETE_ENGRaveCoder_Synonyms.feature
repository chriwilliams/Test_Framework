Feature: Test the full round trip integration from Rave to Coder back to Rave


@WIP
@PB11147-001ETE
@Release2012.2.0
@DE2089
Scenario: Coder will autocode a verbatim that becomes a direct dictionary match in new dictionary version only if there is 1 path in the version and drop the synonym from the previous version.
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
  And I navigate to "Forms" for Form "ETE11" in Draft "Draft 1" for Project "RaveCoderSP<id>"
  And I setup the field "Coder Term 1" to use dictionary "CODER- MedDRA"
  And I configure dictionary to use "LLT" as the coding level
  And I Publish and Push Draft "Draft 1" as "ETE11Draft<l>" in "Prod" environment to All sites
  When I add a subject for study "RaveCoderSP<id>" and site "Active Site" with following values:
    |label              |value          |
    |Subject Initials   |SETE1          |
    |Subject Number     |Mediflex<l>    |
  And I submit verbatim term for the following field on "ETE11" form:
    | Field Name    | Type      | Value       |
    | Adverse Event | long_text | Infusioners |
  And I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And in Coder, I wait for 1 tasks to show up in the task page
  Then in Coder, I should see verbatim term "Infusioners" located in Coder Main Table
  And I take a screenshot
  When in Coder, I Browse and Code Term "HEAD PAIN" on row 1, entering value "Infusion site Bruising" and selecting dictionary tree row 5 and "Do Not Create Synonym"
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I search for subject "Subject_you_created" for study named "RaveCoderSP<id>" and site "Active Site"
  And I open log line 1 for Coder datapoint "Infusioners" on form "ETE1"
  Then I verify the following EDC fields data:
    |General disorders and administration site conditions |
    |10018065                                             |
    |Administration site reactions                        |
    |10001316                                             |
    |Injection and infusion site reactions                |
    |10022097                                             |
    |Infusion site bruising                               |
    |10059203                                             |
    |Infusion site bruising                               |
    |10059203                                             |
  And I take a screenshot
  When I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And in Coder, I create a new Synonym List named "Secondary" using Dictionary "MedDRA", version "11.1" and  Locale "ENG"
  And in Coder, I perform a study migration on Study "RaveCoderSP<id>" using following data:
    | Dictionary | From Version | To Version | From Syn List | To Syn List |
  Then in Coder, I expect to see message "Path Does Not Exist" for synonym migration
  And I take a screenshot
  And in Coder, I perform a synonym migration for list "Primary" from Dictionary Version "MedDRA" and start to reconcile by accepting "first" suggestion
#  When I reconcile selecting Button "1" for category type "Path Does Not Exist" accepting suggestion "Injury, poisoning and procedural complications: 10022117"
#  When I select Button "1" with synonym reconciliation messages
#  # need a better language
#  And I select "Right Arrow Image" to view more options for synonym reconciliation
#  And I accept suggestions with suggested value of "Injury, poisoning and procedural complications: 10022117" for reconciliation
#  And I select Button "Migrate Synonyms"
#  And I verify the migration has completed
  And in Coder, I perform a study migration on Study "RaveCoderSP<id>" using following data:
    |Dictionary       |From Version  |From Syn List   |To Version  |To Syn List   |
    |MedDRA (ENG)     |11.0          |11.1            |Primary     |Secondary     |
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<id>" from iMedidata
  And I search for subject "Subject_you_created" for study named "RaveCoderSP<id>" and site "Active Site"
  And I open log line 1 for Coder datapoint "Infusioners" on form "ETE11"
  And I wait for value "10022117" to appear on form "ETE1" for coded term "Infusioners"
  Then I verify the following EDC fields data:
    | value                                          |
    | Injury, poisoning and procedural complications |
    | 10022117                                       |
    | Administration site reactions                  |
    | 10001316                                       |
    | Infusion site reactions                        |
    | 10068753                                       |
    | Infusion site haematoma                        |
    | 10065463                                       |
    | Infusion site bruising                         |
    | 10059203                                       |
  And I take a screenshot
  And I logout from "Rave"
