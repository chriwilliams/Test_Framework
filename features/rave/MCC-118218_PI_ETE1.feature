@FT_MCC-118218

Feature: MCC-118218 Functional Test of the Primary Investigator (PI)
	As a PI
	When I go to Rave from iMedidata
	So I can verify the assignment and functionality of the PI and other investigators
	
Background:

	
	Given the iMedidata user "AdminUser" exists
	Given the study group "PI Study Group{RndNum<StudyGroupPI>(4)} 1" exists


	Given the following imedidata users exist
		| Login     | First Name | Last Name     | PI Email				|
		| PIUser2	| PI         | User2		 | PIUser2@mdsol.com	|
		| PIUser1A	| PI         | User1A		 | PIUser1A@mdsol.com	|
		| PIUser5A	| PI         | User5A		 | PIUser5A@mdsol.com	|
		| PIUser6	| PI         | User6		 | PIUser6@mdsol.com	|
		| PIUser7	| PI         | User7		 | PIUser7@mdsol.com	|			
		| PIUser9	| PI         | User9		 | PIUser9@mdsol.com	|
		| PIUser12	| PI         | User12		 | PIUser12@mdsol.com	|
		| PIUser14	| PI         | User14		 | PIUser14@mdsol.com	|
		| PIUser16	| PI         | User16		 | PIUser16@mdsol.com	|
	

	Given the following study  assignments exist
		| Login    | Study Group      | Study                      | Environment | Site                      | Site Number            | Rave EDC Link   | Role        | Rave Modules Link   | User Group  | PI Email           |
		| PIUser2  | PI Study Group 1 | Study2{RndNum<Sudy2>(3)}   | Prod        | Site2{RndNum<Site2>(3)}   | {RndNum<Site2_No>(4)}  | <Rave EDC Link> | Invesigator | <Rave Modules Link> | All Modules | PIUser1A@mdsol.com |
		| PIUser1A | PI Study Group 1 | Study1A{RndNum<Sudy1A>(3)} | Prod        | Site1A{RndNum<Site1A>(3)} | {RndNum<Site1A_No>(4)} | <Rave EDC Link> | Invesigator | <Rave Modules Link> | All Modules | PIUser1A@mdsol.com |
		| PIUser5A | PI Study Group 1 | Study5A{RndNum<Sudy%A>(3)} | Prod        | Site5A{RndNum<Site5A>(3)} | {RndNum<Site5A_No>(4)} | <Rave EDC Link> | Invesigator | <Rave Modules Link> | All Modules | PIUser5@mdsol.com  |
		| PIUser6  | PI Study Group 1 | Study6{RndNum<Sudy6>(3)}   | Prod        | Site6{RndNum<Site6(3)}    | {RndNum<Site6_No>(4)}  | <Rave EDC Link> | Invesigator | <Rave Modules Link> | All Modules | PIUser6@mdsol.com  |
		| PIUser7  | PI Study Group 1 | Study7{RndNum<Sudy7>(3)}   | Prod        | Site7{RndNum<Site7>(3)}   | {RndNum<Site7_No>(4)}  | <Rave EDC Link> | Invesigator | <Rave Modules Link> | All Modules | PIUser7@mdsol.com  |
		| PIUser9  | PI Study Group 1 | Study9{RndNum<Sudy9>(3)}   | Prod        | Site9{RndNum<Site9>(3)}   | {RndNum<Site9_No>(4)}  | <Rave EDC Link> | Invesigator | <Rave Modules Link> | All Modules | PIUser9@mdsol.com  |
		| PIUser9  | PI Study Group 1 | Study9{RndNum<Sudy9>(3)}   | Prod        | Site9{RndNum<Site9>(3)}   | {RndNum<Site9_No>(4)}  | <Rave EDC Link> | Read Only   | <Rave Modules Link> |All Modules  | PIUser9@mdsol.com  |
		| PIUser12 | PI Study Group 1 | Study12{RndNum<Sudy12>(3)} | Prod        | Site12{RndNum<Site12>(3)} | {RndNum<Site12_No>(4)} | <Rave EDC Link> | PI Role	  | <Rave Modules Link> |All Modules  | PIUser12@mdsol.com |	
		| PIUser14 | PI Study Group 1 | Study14{RndNum<Sudy14>(3)} | Prod        | Site14{RndNum<Site14>(3)} | {RndNum<Site14_No>(4)} | <Rave EDC Link> | Investigator| <Rave Modules Link> |All Modules  | PIUser14@mdsol.com |	
		| PIUser16 | PI Study Group 1 | Study16{RndNum<Sudy16>(3)} | Prod        | Site16{RndNum<Site16>(3)} | {RndNum<Site16_No>(4)} | <Rave EDC Link> | Investigator| <Rave Modules Link> |All Modules  | PIUser16@mdsol.com |	
		

	Given the following EDC Roles Exist
		| Role         |
		| PI Role      |
		| Investigator |
		| Read Only    |
		
	Given the following eLearning course exists
		| CourseName	| Role		|
		| <Course 1>	| <PI Role> |

	Given the following Internal User exists
		| Login     | email               |
		| defuser   | N/A                 |
		| PIUser1A  | PIUser1A@mdsol.com  |
		| PIUser16A | PIUser16A@mdsol.com |

	Given Study "<Study1A>" is published and pushed to site "<Site1A>"
	Given Study "<Study5A>" is published and pushed to site "<Site5A>"


@release_2014.2.0
@PB_MCC-118218_001
@Draft

Scenario: MCC-118218_001 PI can not be "Removed" or "Edited" in Rave.
	
		Given I login to imedidata with user "<PIUser2>"
		And I am assigned to site "<Site2>" in Study "<Sudy2>" with EDC module "<Rave EDC Link>" and Module "<Rave Module Link>"
		And I select link "<Study2>"
		And I select tab "Sites"
		And I select "<PIUser2>" as the "Principal Investigator"
		And I select link "Home"
		And I select link "<Rave Modules Link>"
		And I select link "Home"
		And I select link "Site Administration"
		And I search for site "<Site2>"
		When I click icon "Investigator"
		Then PI Investigator is displayed in Rave under Study Site Investigator List
		And I see the "P" Identifier in Study Site Investigator List exists
		And I verify the PI Investigator is not editable
		And I take a screenshot
		And I select link "iMedidata"
		And I select link "<Study 2>"
		And I select tab "Sites"
		And I select link "<Site2_No>"
		And I take a screenshot
		When I edit contentents of textbox and save
			| Field                        | Data    | Control type |
			| Principal Investigator Email | <null>	 | textbox      |
		Then the page "Sites" is displayed
		And I verify the following text exists
			|Column					|Data							|
			|Number					|<Site2_No>						|
			|Name					|<Site2>						|
			|Phone					|<blank>						|
			|City					|<blank>						|
			|State/Provence/Region	|<blank>						|
			|Country				|<blank>						|
			|Principal Investigator	|<blank>						|
			|Notes					|<blank>						|
			
		And I take a screenshot

		And I select link "Home"
		And I select link "<Rave Modules Link>"
		And I select link "Home"
		And I select link "Site Administration"
		And I search for site "Site2"
		When I click icon "Investigator"
		Then the PI Investigator is not displayed in Rave under Study Site Investigator List.
		And I see the "P" Identifier in Study Site Investigator List does not exist
		And I take a screenshot

		And I select link "Home"
		And I select link "My Profile"
		And I change Locale to "Localization Test"
		And I select link "LHome"
		And I select link "LSite Administration"


		And I select navigate to the Site Detail page for site "<Site12>"
		When I click icon "LInvestigator"
		Then I verify message "<LSite Principal Investigator Assigned. Awaiting Completion of PI Tasks. Visit iMedidata to Check Progress>" exists
		And I take a screenshot




@release_2014.2.0
@PB_MCC-118218_002
@Draft
	

Scenario: MCC-118218_002
	• If PI is already listed in Rave under Study Site Investigator list and is flagged in iMedidata as a PI
		○ Then user currently listed in Rave Study Site Investigator list will be updated with PI “P” and will only be editable and removable from iMedidata side AND verify New Audit displays on the subject Level.


	Given I login to Rave as user "<PIUser1A>"

	And I select link "Site Administration"
	And I search for site "<Site1A>" in Study "<Sudy1A>"
	When I select icon "Investigator"
	Then I do not see the "P" Identifier in Study Site Investigator List for user "<PIUser1A>
	And I take a screenshot
	Given I login to iMedidata with "AdminUser"
	And I select link "<PI Study Group 1>"
	And I create study "<Sudy1A>" in Environment "Prod"
	And I create site "<Site1A>" in study "<Sudy1A>"
		| Name       | Site Number	 | PI Email              |
		| "<Site1A>" | "<Site1A_No>" |PIUser1A@mdsol.com	 |
	And I invite user "<PIUser1A>" as study owner and site owner to study "<Study1A>" with EDC module "<Rave EDC Link>" and Module "<Rave Module Link>"
	And in iMedidata I activate user "<PIUser1A>"
	And I accept invitation to study "<Study1A>"

	And I accept invitation to site "<Site1A>"

	And I select link "<Rave Modules Link>"
	And I merge accounts
	And I select link "Home"
	And I select link "Site Administration"
	And I search for site "<Site1A>"
	When I select icon "Investigator"
	Then the PI Investigator is displayed in Rave under Study Site Investigator List for user "<PIUser1A>"
	And I do not see user "<PIUser1A>" listed without PI in Study Site Investigator List
	And I verify the PI Investigator is not editable
	And I take a screenshot
	And I select link "Home"
	And I create a subject with user "<PIUser1A>" as the PI
	And I select link "<Primary Form>"
	And I check icon "Audit Form Level"
	When I click link "<Subject>"
	Then I see text "Property 'Current Investigator' set to "<{PIUser1A}>"
	And I take a screenshot
	And I select link "iMedidata"
	And I select link "<Study 1A>"
	And I select tab "Sites"
	And I select link "<Site1A_No>"
	And I take a screenshot
	When I edit contentents of textbox and save
			| Field                        | Data    | Control type |
			| Principal Investigator Email | <null>	 | textbox      |
	Then the page "Sites" is displayed
	And I verify the following text exists
			|Column					|Data							|
			|Number					|<SiteA_No>						|
			|Name					|<SiteA>						|
			|Phone					|<blank>						|
			|City					|<blank>						|
			|State/Provence/Region	|<blank>						|
			|Country				|<blank>						|
			|Principal Investigator	|<blank>						|
			|Notes					|<blank>						|
			
	And I take a screenshot
	And I Select link "Home"
	And I select link "<Rave Modules Link>"
	And I select link "Home"
	And I select link "Site Administration"
	And I search for site "<Site1A>"
	When I check icon "Details" for site "<Site1A>"
	And I verify the following text exists
			|Column					|Data							|
			|Number					|<SiteA_No>						|
			|Name					|<SiteA>						|
			|Phone					|<blank>						|
			|City					|<blank>						|
			|State/Provence/Region	|<blank>						|
			|Country				|<blank>						|
			|Principal Investigator	|<blank>						|
			|Notes					|<blank>						|
	And I take a screenshot
	When I select icon "Investigator
	Then the PI Investigator is displayed in Rave under Study Site Investigator List for user "<PIUser1A>"
	And I take a screenshot

@release_2014.2.0
@PB_MCC-118218_003
@Draft

Scenario: MCC-118218_003
	• If a PI, User A, is already listed in iMedidata, and a Subject is created with User A as investigator, Then PI is updated to User B 
		○ Then previous user in Rave has been removed as a PI and removed from the list of Study Site Investigators AND Navigate to the subject and Verify that next to the Investigator in the Primary for the subject, there is text in Red stating “Investigator is no longer part of the Study Site” and User A is still listed.

	Given I login to iMedidata as user "PIUser5A" 
		
	And I am assigned to site "<Site5A>" in Study "<Sudy5A>" with EDC module "<Rave EDC Link>" and Module "<Rave Module Link>"
	And I select link "<Study5A>"
	And I select tab "<Sites>"

	And I verify and save the following data for "<Site5A>" 
		| Name       | Site Number	 | PI Email              |
		| "<Site5A>" | "<Site5A_No>" |<PIUser5A@mdsol.com>	 |

	And I take a screenshot

	And I select link "Home"
	And I select link "<Rave Module Link>"
	And I select link "Home"
	And I select link "Site Administration"
	And I search for site "<Site5A>"
	When I select icon "Investigator"
	Then the PI Investigator is displayed in Rave under Study Site Investigator List for user "<PIUser5A>"
	And I take a screenshot

	And I select link "Home"
	When I select link "Add Subject"
	Then I see on the "<Primary Form>" the Investigator dropdown
	And I verify user "<PIUser5A>" is in dropdown list
	And I take a screenshot

	And I save the subject as "<Subject1>"

	And I select link "iMedidata"

	And I logout and login as user "<PIUser5B>"

	And I am assigned to site "<Site5A>" in Study "<Sudy5A>" with EDC module "<Rave EDC Link>" and Module "<Rave Module Link>"
	And I select link "<Study5A>"
	And I select tab "<Sites>"

	And I verify and save the following data for "<Site5A>" 
		| Name       | Site Number	 | PI Email              |
		| "<Site5A>" | "<Site5A_No>" |<PIUser5B@mdsol.com>	 |

	And I take a screenshot

	And I select link "Home"
	And I select link "<Rave Module Link>"
	And I select link "Home"
	And I select link "Site Administration"
	And I search for site "<Site5A>"
	When I select icon "Investigator"
	Then the PI Investigator is displayed in Rave under Study Site Investigator List for user "<PIUser5B>"
	And I take a screenshot

	And I select link "Home"
	And I search for subject "<Subject1>"
	When I select link "<Primary Form>"
	Then I verify  user "<PIUser5A>" selected as "PI"
	And I verify text “Investigator is no longer part of the Study Site”
	And I verify that user "<PIUser5B>" is in the dropdown list
	And I take a screenshot
	And I select user "<PIUser5B>" as PI and save
	And I select link "<Primary Form>"
	And I check icon "Audit Form Level"
	When I click link "<Subject>"
	Then I see text "Property 'Current Investigator' set to "<{PIUser5A}>"
	And I see text "Property 'Current Investigator' set to "<{PIUser5B}>"
	And I take a screenshot


@release_2014.2.0
@PB_MCC-118218_004
@Draft


Scenario: MCC-118218_004 If designated PI updates anything (Name, first or last, email, etc.).   Info updates in User admin AND in the PI section of Site admin.
		Given I login to imedidata with user "<PIUser6>"
		And I am assigned to site "<Site6>" in Study "<Sudy6>" with EDC module "<Rave EDC Link>" and Module "<Rave Module Link>"
		And I select link "<Rave Modules Link>"
		And I select link "Home"
		And I select link "Site Administration"
		And I search for site "<Site6>"
		When I select icon "Investigator"
		Then the PI Investigator is displayed in Rave under Study Site Investigator List.
		And I see the "P" Identifier in Study Site Investigator List
		And I take a screenshot
		And I select link "Home"
		And I select link "User Administration"
		And I search for user "<PIUser6>"
		When I click on the icon "Details Icon" for user "<PIUser6>"
		Then the "User Details Page" for user "<PIUser6>" is displayed
		And I take a screenshot
		And I select link "iMedidata"
		And I select link "Account Details"
		And I enter the following data and save
			| Field                 | Data            | Control Type |
			| First Name            | PIx	          | textbox      |
			| Middle Name           | Mname           | textbox      |
			| Last Name             | Userx	          | textbox      |
			| Institution           | Hospital        | textbox      |
			| Title                 | Mr.             | textbox      |
			| Address Line 1        | 100 Main Street | textbox      |
			| Address Line 2        | Building A      | textbox      |
			| Address Line 3        | Suite 4A        | textbox      |
			| Country               | United States   | dropdown     |
			| State/Province/Region | Pennsylvania    | dropdown     |
			| City                  | Ambridge        | textbox      |
			| Postal Code           | 14003           | textbox      |
			| Phone                 | 212-555-1212    | textbox      |
			| Mobile Phone          | 212-565-8000    | textbox      |
			| Fax                   | 201-555-0099    | textbox      |
			| Pager                 | 800-665-1234    | Textbox      |

		And I select link "<Rave Modules Link>"
		And I select link "Home"
		And I select link "Site Administration"
		And I search for site "<Site6>"
		When I select icon "Investigator"
		Then the PI Investigator is displayed in Rave under Study Site Investigator List.
		And I see the "P" Identifier in Study Site Investigator List
		And I take a screenshot
		And I select link "Home"
		And I select link "User Administration"
		And I search for user "<PIUser6>"
		When I click on the icon "Details Icon" for user "<PIUser6>"
		Then the "User Details Page" for user "<PIUser6>" is displayed
		And I take a screenshot
		And I select link "iMedidata"
		And I select link "Account Details"
		And I verify the following data exiats
			| Field                 | Data            | Control Type |
			| First Name            | PIx	          | textbox      |
			| Middle Name           | Mname           | textbox      |
			| Last Name             | Userx	          | textbox      |
			| Institution           | Hospital        | textbox      |
			| Title                 | Mr.             | textbox      |
			| Address Line 1        | 100 Main Street | textbox      |
			| Address Line 2        | Building A      | textbox      |
			| Address Line 3        | Suite 4A        | textbox      |
			| Country               | United States   | dropdown     |
			| State/Province/Region | Pennsylvania    | dropdown     |
			| City                  | Ambridge        | textbox      |
			| Postal Code           | 14003           | textbox      |
			| Phone                 | 212-555-1212    | textbox      |
			| Mobile Phone          | 212-565-8000    | textbox      |
			| Fax                   | 201-555-0099    | textbox      |
			| Pager                 | 800-665-1234    | Textbox      |
		And I take a screenshot


@release_2014.2.0
@PB_MCC-118218_005
@Draft

Scenario: MCC-118218_005 As a User I check “investigator” for User A and User A is an iMedidata User And Assign User A as an Ivestigator For Site 001 for Project Mediflex (PROD).  Then I assign User A as a Primary Investigator(PI) for Site 001 for Project Mediflex (PROD), then User A in Site Admin should be flagged as PI for Site 001 for Project Mediflex (PROD) And if I click “Add”, I should not see any additional User A listed.
		
		Given I login to imedidata with user "<PIUser7>"
		And I am assigned to site "<Site7>" in Study "<Sudy7>" with EDC module "<Rave EDC Link>" and Module "<Rave Module Link>"
		And I select link "<Rave Modules Link>"
		And I select link "Home"
		And I select link "User Administration
		And I search for user "<PIUser7>"
		And I navigate to the User Details page for user "<PIUser7>"
		And I enter the following data and save
			| Field               | Data        | Control Type |
			| Investigator        | <checked>   | checkbox     |
			| Investigator Number | {RndNum(4)} | textbox      |
		And I take a screenshot
		And I select link "Home"
		And I select link "Site Administration"
		And I locate site "<Site7>"
		And I select icon "Investigator"
		When I select link "Add"
		Then I select user "<PIUser7>"
		And the PI Investigator is not displayed
		And I take a screenshot
		And I select link "iMedidata"
		And I select link "<Study7>"
		And I select tab "Sites"
		And I select link "<Site7_No>"
		And I enter the following data and save
			| Field                        | Data                | Control Type |
			| Principal Investigator Email | <PIUser7@mdsol.com> | textbox      |  
		And I select link "Home"
		And I select link "<Rave Modules Link>"
		And I select link "Home"
		And I select link "Site Administration"
		And I locate site "<Site7>"
		And I select icon "Investigator"
		And the PI Investigator is displayed
		And I take a screenshot
		When I select link "Add"
		Then user "<PIUser7>" is not displayed
		And the PI Investigator is displayed
		And I take a screenshot






@release_2014.2.0
@PB_MCC-118218_006
@Draft

Scenario: MCC-118218_006
As a user in iMedidata I Assign User B to Project Mediflex (PROD), with Roles (Read Only and Investigator), and I specify User B as PI for Site 002, then in Rave under Site Admin I should see User B assigned to Site 001 for Project Mediflex (Prod) as a PI and when I click add, to add additional investigators, I should not see additional lists of User B.
		
		Given I login to imedidata with user "<PIUser9>"
		And I am assigned to study "<Study9>" with site "<Site9>" with EDC module "<Rave EDC Link>" and Module "<Rave Module Link>"
		And I select link "<Rave Modules Link>"
		And I select option "<Investigator>" from "Role Selection" dropdown
		And I select link "Home"
		And I select link "Site Administration"
		And I search for site "<Site9>"
		When I select navigate to the Site Detail page for site "<Site9>"
		And I select icon "Investigator"
		Then I verify user "<PIUser9>" is assigned as a PI
		And I take a screenshot
		When I select link "Add"
		Then I see no additional Investigators listed.
		And I take a screenshot
		And I select link "iMedidata"
		And I select link "<Rave Modules Link>"
		And I select option "<Read Only>" from "Role Selection" dropdown
		And I select link "Home"
		And I select link "Site Administration"
		And I search for site "Site9"
		When I navigate to the Site Detail page for site "<Site9>"
		And I select icon "Investigator"
		Then I verify user "<PIUser9>" is assigned as a PI
		And I take a screenshot

		When I select link "Add"
		Then I see no additional Investigators listed.
		And I take a screenshot
		And I select link "iMedidata"
		 



@release_2014.2.0
@PB_MCC-118218_007
@Draft

Scenario: MCC-118218_007
As a user in iMedidata I Assign User B as a PI for Site 004 in Project Mediflex (PROD), without creating the User first, then in Rave I should see under Site Admin for Site 004 in Project Mediflex (Prod) {Pending Message} for PI.  Then User B accepts invite from Project and completes any learning assigned to User B then Pending Message in Rave User Admin for Site 004 in Project Mediflex (Prod) should be removed and User B should be listed as PI with the “P” icon.

	Given I login to iMedidata with user "<AdminUser>"
	And I create study "<Study12>" in Study Group "<StudyGroupPI>"
	And I create a site "<Site12>" for study "<Study12>"
	And I select tab "Sites"
	And I select link "Create New Sites"
	And I enter the following data and save
			| Field       | Data				| Control Type |
			| Name        | <Site12>			| textbox      |
			| Site Number | <Site12_No>			| textbox      |
			| PI Email	  | <PIUser7@mdsol.com> | textbox      |
	And I invite user "<PIUser12>" to study "<Study12>" as study owner and site owner with EDC module "<Rave EDC Link>" and Module "<Rave Module Link>"
	And I take a screenshot

	And I login to Rave with user "defuser"
	And I select link "Site Administration"
	And I select navigate to the Site Detail page for site "<Site12>"
	When I click icon "Investigator"
	Then I verify message "<Site Principal Investigator Assigned. Awaiting Completion of PI Tasks. Visit iMedidata to Check Progress>" exists
	And I take a screenshot

	And I select link "Home"
	And I select link "My Profile"
	And I change Locale to "Localization Test"
	And I select link "LHome"
	And I select link "LSite Administration"
	And I navigate to the Site Detail page for site "<Site12>"
	When I click icon "LInvestigator"
	Then I verify message "<LSite Principal Investigator Assigned. Awaiting Completion of PI Tasks. Visit iMedidata to Check Progress>" exists
	And I take a screenshot

	And I select link "Home"
	And I select link "My Profile"
	And I change Locale to "LEnglish"


	And I log out of Rave
	And I login to iMedidata with user "<PIUser12>" 
	And I accept invitation to study "<Study12>"
	And I accept invitation to site "<Site12>" 
	And I take a screenshot

	And I login to Rave with user "defuser"
	And I select link "Site Administration"
	And I select navigate to the Site Detail page for site "<Site12>"
	When I click icon "Investigator"
	Then I verify message "<Site Principal Investigator Assigned. Awaiting Completion of PI Tasks. Visit iMedidata to Check Progress>" exists
	And I take a screenshot

	And I login to iMedidata with user "<PIUser12>" 
	And I complete eLearning course "<Course 1>"
	And I select link "<Rave Modules Link>"
	And I select link "Home"
	And I select link "Site Administration"
	And I select navigate to the Site Detail page for site "<Site12>"
	When I click icon "Investigator"
	Then the message "<Site Principal Investigator Assigned. Awaiting Completion of PI Tasks. Visit iMedidata to Check Progress>" does not exist
	And I verify user "<PIUser12>" is listed as "PI"
	And I take a screenshot

	And I login to Rave with user "defuser"
	And I select link "Home"
	And I select link "My Profile"
	And I change Locale to "Localization Test"
	And I select link "LHome"
	And I select link "LSite Administration"
	And I select navigate to the Site Detail page for site "<Site12>"
	And I click icon "Investigator"
	And I verify user "<PIUser12>" is listed as "PI"
	When I hover cursor over icon "P"
	Then I see tool tip "<LSite Principal Investigator. Visit iMedidata to Change>"
	And I take a screenshot

	
@release_2014.2.0
@PB_MCC-118218_008
@Draft

Scenario: MCC-118218_008
As a User I assign User A as a Primary Investigator(PI) for Site 001 for Project Mediflex (PROD), then User A in Site Admin should be flagged as PI for Site 001 for Project Mediflex (PROD), then I update PI in iMedidata to empty, then in Rave there should be no PI listed for Site 001.

		Given I login to iMedidata with user "<PIUser14>"
		And I am assigned to study "<Study14>" with site "<Site14>" with EDC module "<PI Role>" and Module "<Rave Module Link>"
		And I select link "<Study14>"
		And I select tab "Sites"
		And I select link "<Site14_No>"
		And I enter the following data and save
			| Field                        | Data                 | Control Type |
			| Principal Investigator Email | <PIUser14@mdsol.com> | textbox      |  
		And I select link "Home"
		And I select link "<Rave Modules Link>"
		And I select link "Home"
		And I select link "Site Administration"
		And I search for site "<Site14>"
		When I click icon "Investigator"
		Then the PI Investigator is displayed in Rave in Study Site Investigator List
		And I see the "P" Identifier in Study Site Investigator List exists
		And I take a screenshot
		And I select link "iMedidata"
		And I select link "<Study14>"
		And I select tab "Sites"
		And I select link "<Site14_No>"
		And I enter the following data and save
			| Field                        | Data           | Control Type |
			| Principal Investigator Email | <blank>		| textbox      |  
		And I take a screenshot
		And I select link "Home"
		And I select link "<Rave Modules Link>"
		And I select link "Home"
		And I select link "Site Administration"
		And I search for site "<Site14>"
		When I click icon "Investigator"
		Then the PI Investigator is not displayed in Rave in Study Site Investigator List.
		And I do not see the "P" Identifier in Study Site Investigator List exists
		And I take a screenshot


@release_2014.2.0
@PB_MCC-118218_009
@Draft

Scenario: MCC-118218_009
As a User I assign User A as a Primary Investigator(PI) for Site 001 for Project Mediflex (PROD), then User A in Site Admin should be flagged as PI for Site 001 for Project Mediflex (PROD), then I Navigate to the Investigator section in Rave for the StudySite, Site 001 for Project Mediflex (Prod), And then I click on “Reassign Investigators” and the Check box next to User A, should not be “check-able”

		
		Given I login to iMedidata with user "<PIUser16>"
		And I am assigned study "<Study16>" with site "<Site16>"
		And I select link "<Study 16>"
		And I select tab "Sites"
		And I select link "<Site16_No>"
		And I enter the following data and save
			| Field                        | Data                 | Control Type |
			| Principal Investigator Email | <PIUser16@mdsol.com> | textbox      |  
		And I select link "Home"
		And I select link "<Rave Modules Link>"
		And I select link "Home"
		And I select link "User Administration"
		And I search for user "<PIUser16A>"
		When I click on the icon "Details Icon" for user "<PIUser16A>"
		And I enter the following data and save
			| Field               | Data       | Control Type |
			| Investigator        | <checked>  | checkbox     |
			| Investigator Number | {RndNum(4) | textbox      |
		And I assign study "<Study16>" with site "<Site16>" to user "<PIUser16A>"
		And I select link "Update"
		And I select Link "Home"
		And I select link "Site Administration"
		And I search for site "Site16"
		And I click icon "Investigator"
		And the PI Investigator"<PIUser16>" is displayed in Rave in Study Site Investigator List.
		And I see the "P" Identifier in Study Site Investigator List exists
		And I select link "Add"
		And I enter and save the folowing data
			| Field             | Data         | Control Type |
			| End Contract Date | <1 Jan 2020> | date time    |
			| Assign            | <checked>    | checkbox     |

		When I select link "Reassign Investigators"
		Then the checkbox next to user "<PIUser16>" is not editable
		And the checkbox next to user "<PIUser16A>" is editable
		And I take a screenshot



