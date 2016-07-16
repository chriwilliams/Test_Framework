Feature: I can access Analytics and Benchmarks Analytics and perform various operations given an existing scenario with pre-existing data

  Background: I am accessing a scenario with pre-existing data via Api Utility Service calls
    Given the following "Client Divisions" exist through the Api Utility Service:
      | app         | user       | client division |
      | studydesign | meditaf_09 | SD_MIST104      |
    And the following "Studies" exist through the Api Utility Service:
      | study  | name                               |
      | study1 | End to End Testing with Data Setup |
    And I delete all scenarios from the study: study1
    And the following "Design Scenarios" exist through the Api Utility Service:
      | client division | study  | name                  | note                      | description                                 | stored as  |
      | SD_MIST104      | study1 | End to End Scenario 1 | First End to End Scenario | This scenario was created with API Services | scenario_1 |
    And the following "Objectives" exist through the Api Utility Service:
      | design scenario | objective_type | description               |
      | scenario_1      | Primary        | First Primary Objective   |
      | scenario_1      | Secondary      | First Secondary Objective |
      | scenario_1      | Tertiary       | First Tertiary Objective  |
      | scenario_1      | Other          | First Other Objective     |
      | scenario_1      | Primary        | Second Primary Objective  |
      | scenario_1      | Other          | Second Other Objective    |
    And the following "Endpoints" exist through the Api Utility Service:
      | design scenario | objective_type | objective_description     | endpoint_type | endpoint_subtype | description |
      | scenario_1      | Primary        | First Primary Objective   | Primary       | Pharmacokinetic  | PP Endpoint |
      | scenario_1      | Secondary      | First Secondary Objective | Secondary     | Efficacy         | SE Endpoint |
      | scenario_1      | Tertiary       | First Tertiary Objective  | Tertiary      | Pharmacoeconomic | TP Endpoint |
      | scenario_1      | Other          | First Other Objective     | Exploratory   | Pharmacodynamic  | EP Endpoint |
      | scenario_1      | Primary        | Second Primary Objective  | Other         | Other            | OO Endpoint |
      | scenario_1      | Other          | Second Other Objective    | Tertiary      | Safety           | TS Endpoint |
      | scenario_1      | Primary        | First Primary Objective   | Primary       | Quality of life  | PQ Endpoint |
    And the following "Scenario Schedules" exist through the Api Utility Service:
      | design scenario | schedule name | stored as  |
      | scenario_1      | Main Schedule | schedule_1 |
      | scenario_1      | Base Schedule | schedule_2 |
    And the following "Activities" exist through the Api Utility Service:
      | design scenario | schedule   | activity                            |
      | scenario_1      | schedule_1 | Isol. Highly Purified Nucleic Acid  |
      | scenario_1      | schedule_1 | Direct Coombs Test                  |
      | scenario_1      | schedule_1 | Follicle Stimulating Hormone (FSH)  |
      | scenario_1      | schedule_1 | Informed Consent Process            |
      | scenario_1      | schedule_1 | Follicle Stimulating Hormone (FSH)  |
      | scenario_1      | schedule_1 | Molecular Diag, Interp & Report     |
      | scenario_1      | schedule_1 | SMAC 12: 5-12 Chemistries           |
      | scenario_1      | schedule_1 | Physical Performance Test           |
      | scenario_1      | schedule_1 | Hemogram (CBC) w/ Plate & Auto Diff |
      | scenario_1      | schedule_1 | Serum Sodium                        |
      | scenario_1      | schedule_1 | Brief Pain Inventory Short Form     |
      | scenario_1      | schedule_1 | Drug ID Questionnaire               |
      | scenario_1      | schedule_1 | Physicians Withdrawal Checklist     |
      | scenario_1      | schedule_1 | Fungal Culture, Other               |
      | scenario_1      | schedule_1 | Prealbumin                          |
      | scenario_1      | schedule_1 | Urine Pregnancy Test, Qualitative   |
      | scenario_1      | schedule_1 | Brief Neurological Exam             |
      | scenario_1      | schedule_1 | Gel Electrophoresis Separation      |
      | scenario_1      | schedule_1 | HIV Ab Confirmation (Western Blot)  |
      | scenario_1      | schedule_1 | Thyroid Stimulating Hormone         |
      | scenario_1      | schedule_1 | Molecular DNA Probe, Each           |
    And the following "Study Events" exist through the Api Utility Service:
      | design scenario | schedule   | event    | encounter type     | visit type        |
      | scenario_1      | schedule_1 | Visit 1  | Visit Inpatient    | Treatment         |
      | scenario_1      | schedule_1 | Visit 2  | Phone              | Screening         |
      | scenario_1      | schedule_1 | Visit 3  | Phone              | Treatment         |
      | scenario_1      | schedule_1 | Visit 4  | Other              | Extension         |
      | scenario_1      | schedule_1 | Visit 5  | Visit - Outpatient | Treatment         |
      | scenario_1      | schedule_1 | Visit 6  | ePRO               | Treatment         |
      | scenario_1      | schedule_1 | Visit 7  | Other              | Randomization     |
      | scenario_1      | schedule_1 | Visit 8  | Visit - Outpatient | Extension         |
      | scenario_1      | schedule_1 | Visit 9  | Visit - Outpatient | Treatment         |
      | scenario_1      | schedule_1 | Visit 10 | ePRO               | Randomization     |
      | scenario_1      | schedule_1 | Visit 11 | Visit - Outpatient | Treatment         |
      | scenario_1      | schedule_1 | Visit 12 | Visit - Outpatient | Treatment         |
      | scenario_1      | schedule_1 | Visit 13 | Other              | Screening         |
      | scenario_1      | schedule_1 | Visit 14 | Visit - Outpatient | Treatment         |
      | scenario_1      | schedule_1 | Visit 15 | Visit - Outpatient | Extension         |
      | scenario_1      | schedule_1 | Visit 16 | Visit - Inpatient  | Randomization     |
      | scenario_1      | schedule_1 | Visit 17 | Visit - Inpatient  | Screening         |
      | scenario_1      | schedule_1 | Visit 18 | Visit - Outpatient | Baseline          |
      | scenario_1      | schedule_1 | Visit 19 | Visit - Outpatient | Randomization     |
      | scenario_1      | schedule_1 | Visit 20 | Visit - Inpatient  | Treatment         |
      | scenario_1      | schedule_1 | Visit 21 | Phone              | Treatment         |
      | scenario_1      | schedule_1 | Visit 22 | Visit - Outpatient | Early Termination |
      | scenario_1      | schedule_1 | Visit 23 | Visit - Inpatient  | Treatment         |
      | scenario_1      | schedule_1 | Visit 24 | Other              | Treatment         |
      | scenario_1      | schedule_1 | Visit 25 | Phone              | Extension         |
    And the following "Study Cells" exist through the Api Utility Service:
      | design scenario | schedule   | activity                            | event    |
      | scenario_1      | schedule_1 | Isol. Highly Purified Nucleic Acid  | Visit 1  |
      | scenario_1      | schedule_1 | Direct Coombs Test                  | Visit 1  |
      | scenario_1      | schedule_1 | Direct Coombs Test                  | Visit 2  |
      | scenario_1      | schedule_1 | Serum Sodium                        | Visit 3  |
      | scenario_1      | schedule_1 | Isol. Highly Purified Nucleic Acid  | Visit 3  |
      | scenario_1      | schedule_1 | Direct Coombs Test                  | Visit 4  |
      | scenario_1      | schedule_1 | Follicle Stimulating Hormone (FSH)  | Visit 5  |
      | scenario_1      | schedule_1 | Informed Consent Process            | Visit 6  |
      | scenario_1      | schedule_1 | Follicle Stimulating Hormone (FSH)  | Visit 7  |
      | scenario_1      | schedule_1 | SMAC 12: 5-12 Chemistries           | Visit 8  |
      | scenario_1      | schedule_1 | Physical Performance Test           | Visit 9  |
      | scenario_1      | schedule_1 | Hemogram (CBC) w/ Plate & Auto Diff | Visit 3  |
      | scenario_1      | schedule_1 | Hemogram (CBC) w/ Plate & Auto Diff | Visit 10 |
      | scenario_1      | schedule_1 | Serum Sodium                        | Visit 11 |
      | scenario_1      | schedule_1 | Drug ID Questionnaire               | Visit 12 |
      | scenario_1      | schedule_1 | Physicians Withdrawal Checklist     | Visit 13 |
      | scenario_1      | schedule_1 | Fungal Culture, Other               | Visit 14 |
      | scenario_1      | schedule_1 | Prealbumin                          | Visit 15 |
      | scenario_1      | schedule_1 | Urine Pregnancy Test, Qualitative   | Visit 16 |
      | scenario_1      | schedule_1 | Brief Neurological Exam             | Visit 17 |
      | scenario_1      | schedule_1 | Direct Coombs Test                  | Visit 18 |
      | scenario_1      | schedule_1 | Follicle Stimulating Hormone (FSH)  | Visit 19 |
      | scenario_1      | schedule_1 | Informed Consent Process            | Visit 20 |
      | scenario_1      | schedule_1 | Follicle Stimulating Hormone (FSH)  | Visit 21 |
      | scenario_1      | schedule_1 | SMAC 12: 5-12 Chemistries           | Visit 22 |
      | scenario_1      | schedule_1 | Physical Performance Test           | Visit 23 |
      | scenario_1      | schedule_1 | Hemogram (CBC) w/ Plate & Auto Diff | Visit 24 |
      | scenario_1      | schedule_1 | Thyroid Stimulating Hormone         | Visit 1  |
      | scenario_1      | schedule_1 | Molecular DNA Probe, Each           | Visit 2  |
      | scenario_1      | schedule_1 | Molecular Diag, Interp & Report     | Visit 7  |
      | scenario_1      | schedule_1 | Molecular Diag, Interp & Report     | Visit 9  |
      | scenario_1      | schedule_1 | Molecular Diag, Interp & Report     | Visit 11 |
      | scenario_1      | schedule_1 | Thyroid Stimulating Hormone         | Visit 10 |
      | scenario_1      | schedule_1 | Molecular DNA Probe, Each           | Visit 3  |
      | scenario_1      | schedule_1 | Follicle Stimulating Hormone (FSH)  | Visit 12 |
      | scenario_1      | schedule_1 | Urine Pregnancy Test, Qualitative   | Visit 12 |
      | scenario_1      | schedule_1 | Isol. Highly Purified Nucleic Acid  | Visit 7  |
      | scenario_1      | schedule_1 | Brief Pain Inventory Short Form     | Visit 5  |
      | scenario_1      | schedule_1 | Brief Pain Inventory Short Form     | Visit 9  |
      | scenario_1      | schedule_1 | Brief Pain Inventory Short Form     | Visit 25 |
      | scenario_1      | schedule_1 | Molecular DNA Probe, Each           | Visit 9  |
      | scenario_1      | schedule_1 | HIV Ab Confirmation (Western Blot)  | Visit 6  |
    And I assign Purpose for study cell with activity "Thyroid Stimulating Hormone" and visit "Visit 1" through the Api Utility Service:
      | type    | subtype         | purpose     | purpose type | objective type | objective description   |
      | Primary | Pharmacokinetic | PP Endpoint | endpoint     | Primary        | First Primary Objective |
    And I assign Purpose for study cell with activity "Thyroid Stimulating Hormone" and visit "Visit 10" through the Api Utility Service:
      | type      | subtype         | purpose     | purpose type | objective type | objective description   |
      | Primary   | Pharmacokinetic | PP Endpoint | endpoint     | Primary        | First Primary Objective |
      | Screening |                 | Screening   | other        |                |                         |
    And I assign Purpose for study cell with activity "Molecular DNA Probe, Each" and visit "Visit 2" through the Api Utility Service:
      | type    | subtype         | purpose     | purpose type | objective type | objective description   |
      | Primary | Pharmacokinetic | PP Endpoint | endpoint     | Primary        | First Primary Objective |
    And I assign Purpose for study cell with activity "Molecular Diag, Interp & Report" and visit "Visit 7" through the Api Utility Service:
      | type        | subtype         | purpose     | purpose type | objective type | objective description |
      | Exploratory | Pharmacodynamic | EP Endpoint | endpoint     | Other          | First Other Objective |
    And I assign Purpose for study cell with activity "Molecular Diag, Interp & Report" and visit "Visit 9" through the Api Utility Service:
      | type      | subtype  | purpose     | purpose type | objective type | objective description     |
      | Secondary | Efficacy | SE Endpoint | endpoint     | Secondary      | First Secondary Objective |
    And I assign Purpose for study cell with activity "Molecular Diag, Interp & Report" and visit "Visit 11" through the Api Utility Service:
      | type        | subtype         | purpose     | purpose type | objective type | objective description |
      | Exploratory | Pharmacodynamic | EP Endpoint | endpoint     | Other          | First Other Objective |
    And I assign Optional Conditional to the following study cells in schedule_1 through the Api Utility Service:
      | activity                            | event    | minimum required quantity | optional conditional type                                       | optional quantity | percentage of subjects |
      | Thyroid Stimulating Hormone         | Visit 1  | 1                         | Specified Medical History / Condition                           | 20                | 75                     |
      | Molecular DNA Probe, Each           | Visit 3  | 5                         | Specified Subject Gender                                        | 20                | 65                     |
      | Follicle Stimulating Hormone (FSH)  | Visit 12 | 0                         | Procedure Not Previously Performed Within Specified Time Period | 1                 | 45                     |
      | Hemogram (CBC) w/ Plate & Auto Diff | Visit 3  | 4                         | Procedure Not Previously Performed Within Specified Time Period | 25                | 25                     |
      | Urine Pregnancy Test, Qualitative   | Visit 12 | 3                         | As Clinically Warranted                                         | 20                | 10                     |
      | Isol. Highly Purified Nucleic Acid  | Visit 7  | 8                         | Until Valid Reading Recorded                                    | 10                | 10                     |
      | Molecular Diag, Interp & Report     | Visit 9  | 11                        | As Clinically Warranted                                         | 10                | 5                      |
      | Brief Pain Inventory Short Form     | Visit 5  | 15                        | Until Valid Reading Recorded                                    | 20                | 25                     |
      | Molecular DNA Probe, Each           | Visit 9  | 20                        | Optional or Conditional - Other                                 | 10                | 10                     |
    And I assign Visit Optional Conditional to the following study events in schedule_1 through the Api Utility Service:
      | event   | optional conditional type                   | percentage of subjects |
      | Visit 2 | Unscheduled - Early Withdrawal              | 25                     |
      | Visit 3 | Scheduled - Conditional on Procedure Result | 50                     |
      | Visit 6 | Scheduled - Conditional on Procedure Result | 75                     |
      | Visit 9 | Unscheduled - In Case of Adverse Event      | 100                    |

  @Release2015.1.0
  @PB137170-01
  @selenium
  @StudyDesign
  @Validation
  Scenario: Add new cells for existing study/scenario/schedule and verify recalculated Per Subject Cost and Complexity.
    Given I login to "iMedidata" as user "meditaf_09"
    And I am in Design Optimization for study group "SD_MIST104" and study "End to End Testing with Data Setup"
    And in Design Optimization, I navigate to scenario "scenario_1"
    And I take a screenshot
    And in Design Optimization, I navigate to the Analytics page for schedule: "schedule_1"
    And in Design Optimization, I note the current cost and complexity
    And I take a screenshot
    And in Design Optimization, I navigate to the Schedule page for schedule: "schedule_1"
    And in Design Optimization, I navigate to Schedule Grid tab
    And I take a screenshot
    And in Design Optimization, I select the following cells:
      | activity                           | visit    |
      | Gel Electrophoresis Separation     | Visit 12 |
      | HIV Ab Confirmation (Western Blot) | Visit 10 |
      | Gel Electrophoresis Separation     | Visit 11 |
    And I take a screenshot
    And in Design Optimization, I assign purpose to the following cells:
      | activity                           | visit    | type    | subtype         | description |
      | Gel Electrophoresis Separation     | Visit 12 | Primary | Pharmacokinetic | PP Endpoint |
      | HIV Ab Confirmation (Western Blot) | Visit 10 | Primary | Quality of life | PQ Endpoint |
      | Gel Electrophoresis Separation     | Visit 11 | Other   | Other           | OO Endpoint |
    And in Design Optimization, I navigate to the Analytics page for schedule: "schedule_1"
    And in Design Optimization, I verify the Cost Per Subject has increased
    And in Design Optimization, I verify the Complexity Per Subject has increased
    And I take a screenshot
    And I logout from "iMedidata"

  @Release2015.1.0
  @PB141814-01
  @selenium
  @studydesign
  @Validation
  Scenario: Remove cells from existing study/scenario/schedule and verify recalculated Per Subject Cost and Complexity.
    Given I login to "iMedidata" as user "meditaf_09"
    And I am in Design Optimization for study group "SD_MIST104" and study "End to End Testing with Data Setup"
    And in Design Optimization, I navigate to scenario "scenario_1"
    And I take a screenshot
    And in Design Optimization, I navigate to the Analytics page for schedule: "schedule_1"
    And in Design Optimization, I note the current cost and complexity
    And I take a screenshot
    And in Design Optimization, I navigate to the Schedule page for schedule: "schedule_1"
    And in Design Optimization, I navigate to Schedule Grid tab
    And I take a screenshot
    And in Design Optimization, I unselect the following cells:
      | activity                           | visit   |
      | Brief Pain Inventory Short Form    | Visit 5 |
      | Brief Pain Inventory Short Form    | Visit 9 |
      | HIV Ab Confirmation (Western Blot) | Visit 6 |
    And I take a screenshot
    And in Design Optimization, I navigate to the Analytics page for schedule: "schedule_1"
    And in Design Optimization, I verify the Cost Per Subject has decreased
    And in Design Optimization, I verify the Complexity Per Subject has decreased
    And I take a screenshot
    And I logout from "iMedidata"

  @Release2015.1.0
  @PB141825-01
  @selenium
  @studydesign
  @Validation
  Scenario: Remove some Visits and Activities from existing study/scenario/schedule and verify recalculated Per Subject Cost(with existing cells).
    Given I login to "iMedidata" as user "meditaf_09"
    And I am in Design Optimization for study group "SD_MIST104" and study "End to End Testing with Data Setup"
    And in Design Optimization, I navigate to scenario "scenario_1"
    And I take a screenshot
    And in Design Optimization, I navigate to the Analytics page for schedule: "schedule_1"
    And in Design Optimization, I note the current cost and complexity
    And I take a screenshot
    And in Design Optimization, I navigate to the Schedule page for schedule: "schedule_1"
    And in Design Optimization, I navigate to Activities tab
    And I take a screenshot
    And in Design Optimization, I remove the following "Activities":
      | activity name               | is linked |
      | Thyroid Stimulating Hormone | yes       |
      | Molecular DNA Probe, Each   | yes       |
    And I take a screenshot
    And in Design Optimization, I navigate to the Analytics page for schedule: "schedule_1"
    And in Design Optimization, I verify the Cost Per Subject has decreased
    And in Design Optimization, I verify the Complexity Per Subject has decreased
    And in Design Optimization, I note the current cost and complexity
    And I take a screenshot
    And in Design Optimization, I navigate to the Schedule page for schedule: "schedule_1"
    And in Design Optimization, I navigate to Visits tab
    And I take a screenshot
    And in Design Optimization, I remove the following "Visits":
      | encounter type     | visit type    | visit name | is linked |
      | Other              | Randomization | Visit 7    | yes       |
      | Visit - Outpatient | Extension     | Visit 8    | yes       |
    And I take a screenshot
    And in Design Optimization, I navigate to the Analytics page for schedule: "schedule_1"
    And in Design Optimization, I verify the Cost Per Subject has decreased
    And in Design Optimization, I verify the Complexity Per Subject has decreased
    And I take a screenshot
    And I logout from "iMedidata"

  @Release2015.1.0
  @PB142168-01
  @selenium
  @StudyDesign
  @Validation
  Scenario: Add more Visits and Activities to existing study/scenario/schedule and verify recalculated Per Subject Cost (with new cells).
    Given I login to "iMedidata" as user "meditaf_09"
    And I am in Design Optimization for study group "SD_MIST104" and study "End to End Testing with Data Setup"
    And in Design Optimization, I navigate to scenario "scenario_1"
    And I take a screenshot
    And in Design Optimization, I navigate to the Analytics page for schedule: "schedule_1"
    And in Design Optimization, I note the current cost and complexity
    And I take a screenshot
    And in Design Optimization, I navigate to the Schedule page for schedule: "schedule_1"
    And in Design Optimization, I navigate to Activities tab
    And I take a screenshot
    And in Design Optimization, I add the following "Activities" and verify protocol usage:
      | activity name               | code  | protocol usage |
      | Thyroid Stimulating Hormone | 84443 | 3.70%          |
      | Prothrombin Time (PT)       | 85610 | 50.00%         |
    And in Design Optimization, I navigate to Visits tab
    And in Design Optimization, I add the following "Visits":
      | encounter type    | visit type    | visit name |
      | Visit - Inpatient | Randomization | Visit 26   |
      | Phone             | Randomization | Visit 27   |
    And in Design Optimization, I navigate to Schedule Grid tab
    And I take a screenshot
    And in Design Optimization, I select the following cells:
      | activity                         | visit    |
      | Thyroid Stimulating Hormone >[2] | Visit 26 |
      | Prothrombin Time (PT)            | Visit 27 |
    And I take a screenshot
    And in Design Optimization, I navigate to the Analytics page for schedule: "schedule_1"
    And in Design Optimization, I verify the Cost Per Subject has increased
    And in Design Optimization, I verify the Complexity Per Subject has increased
    And I take a screenshot
    And I logout from "iMedidata"

  @Release2015.1.0
  @PB142169-01
  @selenium
  @StudyDesign
  @Validation
  Scenario: Update quantity on existing cells from existing study/scenario/schedule and verify recalculated Per Subject Cost.
    Given I login to "iMedidata" as user "meditaf_09"
    And I am in Design Optimization for study group "SD_MIST104" and study "End to End Testing with Data Setup"
    And in Design Optimization, I navigate to scenario "scenario_1"
    And I take a screenshot
    And in Design Optimization, I navigate to the Analytics page for schedule: "schedule_1"
    And in Design Optimization, I note the current cost and complexity
    And I take a screenshot
    And in Design Optimization, I navigate to the Schedule page for schedule: "schedule_1"
    And in Design Optimization, I navigate to Schedule Grid tab
    And I take a screenshot
    And in Design Optimization, I assign quantity & optional conditional in Single Selection mode to the following cells:
      | activity                        | visit    | minimum | optional conditional type    | optional quantity | optional percentage |
      | Thyroid Stimulating Hormone     | Visit 10 | 60      |                              |                   |                     |
      | Brief Pain Inventory Short Form | Visit 25 |         | Specified Subject Gender     | 80                | 85                  |
      | Informed Consent Process        | Visit 20 |         | Until Valid Reading Recorded | 70                |                     |
    And I take a screenshot
    And in Design Optimization, I navigate to the Analytics page for schedule: "schedule_1"
    And in Design Optimization, I verify the Cost Per Subject has increased
    And in Design Optimization, I verify the Complexity Per Subject has increased
    And I take a screenshot
    And I logout from "iMedidata"
