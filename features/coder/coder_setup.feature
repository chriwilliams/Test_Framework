Feature: Coder admin will have full privilege to add license, remove license for any dictionary and roll out or revoke rights of any dictionary.

@VAL
@PB1.2.3-001
@Release2014.2.0
Scenario: An admin user should be able to add a license key for a version and roll out dictionaries
  Given I login to "imedidata" as user "coderadmin"
  And I navigate to "Coder" for study group "MedidataReserved1" from iMedidata
  When I navigate to "Medidata Admin Console" page from Admin list
  And I select segment "CVREG1(CVReg1)" and dictionary "MedDRAMedHistory (eng)"
  And I add a license key with the following data:
    | License Code    | Start Date    | End Date    |
    | abc123          | 1/1/2000      | 1/1/2050    |
  And I select segment "CVREG1(CVReg1)" and dictionary "MedDRAMedHistory (jpn)"
  And I add a license key with the following data:
    | License Code    | Start Date    | End Date    |
    | abc123          | 1/1/2000      | 1/1/2050    |
  And I roll out all version for dictionary "MedDRA (jpn)" from the first page
  And I roll out all version for dictionary "JDrug (jpn)" from the first page

@VAL
@PB1.2.3-002
@Release2014.2.0
Scenario: An admin user should be able to add a license key for a version and roll out dictionaries
  Given I login to "imedidata" as user "coderadmin"
  And I navigate to "Coder" for study group "MedidataReserved1" from iMedidata
  When I navigate to "Segment Management" page from Admin list
  And I enroll a new segment named "Some Segment" in Coder application
  And I create and assign workflow role named "WorkflowNameTest1" on Workflow page
  And I assign a workflow role to user "coderadmin" with role "CoderAdmin" for "All Studies"
  And I logout from "coder"