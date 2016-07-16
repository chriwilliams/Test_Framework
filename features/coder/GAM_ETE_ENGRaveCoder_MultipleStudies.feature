Feature: Test the full round trip integration from Rave to Coder back to Rave


@DFT
@PB1.1.2-016
@Release2014.3.0
Scenario: Test that Rave is able to send coding terms to Coder even when more than 1 study is on the same Rave URL
  Given I login to "iMedidata" as user "rave_coder<i1>"
#  And I create "PROD,UAT,DEV" (study|study set) named "RaveCoderStudy<l>" and site named "RaveCoderSite<l>" within study group named "RaveCoderStudyGroup<i1>"
  And I create "PROD,UAT,DEV" study set named "RaveCoderStudy<l>" and site named "RaveCoderSite" within study group named "RaveCoderStudyGroup<l>"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<i2>" from iMedidata
#Todo:
  And I create and setup a new Coder draft "Draft 1" for study "RaveCoderStudy<l>" with form "options" in Rave:
    | Form Name         | Form_RC_Study<l> |
    | VarOID            | VOID_RC_Study<l> |
    | Format            | $50              |
    | Field Name        | FN_RC_Study<l>   |
    | Field OID         | FOID_RC_Study<l> |
    | Field Label       | FL_RC_Study<l>   |
    | Matrix Name       | Primary          |
    | Signature Message | Signature Test   |
# Note: the study name has to come from $sticky for z0RaveCoderStudy
# Suggested Steps:
#  And I add a form named "z0RaveCoderStudy with OID "z0RaveCoderStudy<l>" in "Draft 1"
#  And I configure form "z0RaveCoderStudy" with the following values:
#  And I add a Matrix named Primary for Study "z0RaveCoderStudy" for "Draft 1"
#  And I update the Matrix checkbox for Matrix "Primary"
#  And I update CRF Draft "Draft 1" settings with "Primary" as Default Matrix with a Signature Prompt
#  And I enter value "test" in the "Signature Prompt Text Field"
# Granular Steps from above:
#    And I select Link "Architect"
#    And I select Link "z0<CoderRaveStudy>"
#    And I select Link "Add New Draft"
#    And I enter value "Draft 1" in the "Draft Name Text Field"
#    And I select Button "Rave Create Draft Button"
#    And I select Link "Forms"
#    And I select Link "Add Form"
#    And I set value "Top" located in "Form Dropdown"
#    And I enter value "Field1<CoderRaveStudy>" in the "Name Text Field"
#    And I enter value "Field1<CoderRaveStudy>" in the "Form OID Text Field"
#    And I select Link "Update"
#    And I select Image "Details Image"
#    And I select Link "Add New"
#    And I enter value "VOID<CoderRaveStudy>" in the "VarOID Text Field"
#    And I enter value "$50" in the "Format Text Field"
#    And I enter value "VOID<CoderRaveStudy>" in the "Field Name Text Field"
#    And I enter value "VOID<CoderRaveStudy>" in the "Field OID Text Field"
#    And I enter value "VOID<CoderRaveStudy>" in the "Field Label Text Field"
#    And I select Link "Save"
#    And With data below, I select Link "<link>"
#      |link                 |
#      |z0<CoderRaveStudy>   |
#      |Draft 1              |
#      |Matrices             |
#      |Add Matrix           |
#    And I enter value "Primary" in the "Matrix Name"
#    And I enter value "Primary<CoderRaveStudy>" in the "Matrix OID"
#    And I select Link "Update"
#    And I select Image "Details Image"
#    And I select Link "Edit"
#    And I check the "Matrix Checkbox"
#    And I select Link "Save"
#    And I select Link "Draft 1"
#    And I select Link "Edit"
#    And I set value "Primary" located in "Default Matrix Dropdown"
#    And I enter value "test" in the "Signature Prompt Text Field"
#    And I select Link "Save"
#EndofTodo
  And I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<i2>" from iMedidata
  And in Coder, I set coder defaults with the following options:
    | Dictionary     | MedDRA                                                                  |
    | version        | 11.0                                                                    |
    | locale         | ENG                                                                     |
    | syn_list_name  | Primary                                                                 |
    | primary_path   | ON                                                                      |
    | Synonym_Policy | Active                                                                  |
    | project        | z0RaveCoderStudy<l>,z0RaveCoderStudy<l> (DEV),z0RaveCoderStudy<l> (UAT) |
  ## multiple studies is not handled by the step used. You can use only one study
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<i2>" from iMedidata
  And I navigate to "Forms" for Form "ETE12" in Draft "Draft 1" for Project "z0RaveCoderStudy<l>"
  And I setup the field "CREATED FIELD" to use dictionary "CODER- MedDRA"
  And I configure dictionary to use "LLT" as the coding level
  And I navigate to "Forms" for Form "CREATED FIELD" in Draft "Draft 1" for Project "RaveCoderSP<i2>"
  And I Publish and Push Draft "Draft 1" as "Draft 1_v1" in "PROD,DEV,UAT" environment to All sites
# TODO
  And I configure coder import user for study "RaveCoderStudy<l>" with environmental option "Aux: UAT, Aux: DEV"
#NOTE: coderimport value is the only option available given it's a rave system default user, this can be hard-coded
#   Granular Steps
#    And I select Link "User Administration"
#    And I enter value "coderimport" in the "Log In Text Field"
#    And I select Link "Search"
#    And I select Image "Right Arrow Image" located in "Rave User Admin Table" row labeled "CoderImport"
#    And I select Link "Assign to Study"
#    And I set value "Coder Import Role" located in "User Studies Role Dropdown"
#    And I set value "z0<CoderRaveStudy>" located in "User Studies Dropdown" and wait for "2"
#    And I set value "Aux: UAT" located in "User Studies Environment Dropdown"
#    And I select Link "Assign User"
#    And I select Link "Assign to Study"
#    And I set value "Coder Import Role" located in "User Studies Role Dropdown"
#    And I set value "z0<CoderRaveStudy>" located in "User Studies Dropdown" and wait for "2"
#    And I set value "Aux: DEV" located in "User Studies Environment Dropdown"
#    And I select Link "Assign User"
#    And I select Link "Home"
# EndofTODO
  #TODO
#  When I am on add subject page for study "RaveCoderStudy<i>"
  When in RaveX I am on add subject page for project "RaveCoderStudy<l>"
  #endofTODO
  And I add a subject in RaveX with the following data:
    | Field Name       | Type | Value                       |
    | Subject Initials | text | SETE1                       |
    | Subject Number   | text | z0<CoderRaveStudy> (DEV)<l> |
#    And I enter value "z0<CoderRaveStudy>" in the "Search Text Field"
#    And I select Link "Search Icon in EDC"
#    And I select Link "z0<CoderRaveStudy> (DEV)"
#    And I select Link "Add Subject"
#    And I enter value "SETE161<CoderRaveStudy>" in the "Std Text Field"
#    And I select Button "Rave Subject Save Button"
# TODO
  And I enter the following data for the "CoderRaveStudy> (DEV)<l>" RaveX form:
    | Field Name   | Type | Value             |
    | FL_RC_Study<l> | text | LOWER BACK PAIN 1 |
# endofTODO
  #TODO
  When I am on add subject page for project "RaveCoderSP<i2>" in RaveX
  #endofTODO
  And I add a subject in RaveX with the following data:
    | Field Name       | Type | Value       |
    | Subject Initials | text | SETE1       |
    | Subject Number   | text | Mediflex<l> |
  #TODO
  And I enter the following RaveX data for the "" form:
    | Field Name     | Type | Value             |
    | FL_RC_Study<l> | text | LOWER BACK PAIN 2 |
  And I navigate to iMedidata from "Rave"
  And I navigate to "Coder" for study group "RaveCoderStudyGroup<i2>" from iMedidata
  Then in Coder, I wait for 2 tasks to show up in the task page
  And in Coder, I expect to see the following verbatim terms in Coder Main Table
    |value                |
    |lower back pain 1    |
    |lower back pain 2    |
  And I take a screenshot
  When in Coder, I Browse and Code Term "lower back pain 1" on row 1, entering value "complicated migraine" and selecting dictionary tree row 5 and "Create Synonym"
  And in Coder, I Browse and Code Term "lower back pain 2" on row 1, entering value "complicated migraine" and selecting dictionary tree row 5 and "Create Synonym"
  And I navigate to iMedidata from "Coder"
  And I navigate to "Rave EDC" for study group "RaveCoderStudyGroup<i2>" from iMedidata
  And I search for subject "Subject_you_created" for study named "z0<CoderRaveStudy> (DEV)" and site "Active Site"
  And I open log line 1 for Coder datapoint "LOWER BACK PAIN 1" on form "Field1<CoderRaveStudy>"
  #TODO
  And I wait for value "Complicated Migraine" to appear on RaveX form "Field1<CoderRaveStudy>" for coded term "LOWEER BACK PAIN 2"
  #endofTODO
#TODO
  Then I verify the following RaveX fields data:
    | value                    |
    | Nervous system disorders |
    | SOC                      |
    | 10029205                 |
    | Headaches                |
    | HLGT                     |
    | 10019231                 |
    | Migraine headaches       |
    | HLT                      |
    | 10027603                 |
    | Complicated migraine     |
    | PT                       |
    | 10056236                 |
#endofTODO
  And I take a screenshot
  When I search for subject "Subject_you_created" for study named "z0<CoderRaveStudy> (DEV)" and site "Active Site"
  And I open log line 1 for Coder datapoint "LOWER BACK PAIN 2" on form "Field1<CoderRaveStudy>"
#TODO
  And I wait for value "Complicated migraine" to appear on RaveX form "ETE12" for coded term "LOWEER BACK PAIN 2"
#endofTODO
  Then I verify the following RaveX fields data:
    | Nervous system disorders |
    | SOC                      |
    | 10029205                 |
    | Headaches                |
    | HLGT                     |
    | 10019231                 |
    | Migraine headaches       |
    | HLT                      |
    | 10027603                 |
    | Complicated migraine     |
    | PT                       |
    | 10056236                 |
  And I take a screenshot
  And I logout from "Rave"
