Feature: This feature confirms and verifies that changes pertaining to phase and/or indication affect activities and cost information

  Background: Using the Api utility service information about the study is created including references information:

  Background: I am accessing a scenario with pre-existing data via Api Utility Service calls
    Given the following "Client Divisions" exist through the Api Utility Service:
      | app         | user       | client division |
      | studydesign | meditaf_09 | SD_MIST104      |
    And the following "Studies" exist through the Api Utility Service:
      | study  | name                               |
      | study2 | Editable References Scenario Study |
    And I update the following "References" through the Api Utility Service:
      | client division      | SD_MIST104                                                                 |
      | study                | study2                                                                     |
      | phase                | Phase V                                                                    |
      | primary indication   | 437.1: Generalized Ischemic Cerebrovascular Disease, Brain Ischemia        |
      | secondary indication | 985.9: Poisoning, Toxic Effect of Unspecified Metal, Heavy Metal Poisoning |
    And I delete all scenarios from the study: study2
    And the following "Design Scenarios" exist through the Api Utility Service:
      | client division | study  | name          | note                      | description                                 | stored as  |
      | SD_MIST104      | study2 | Main Scenario | First End to End Scenario | This scenario was created with API Services | scenario_1 |
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
      | scenario_1      | Other          | Second Other Objective    | Exploratory   | Pharmacoeconomic | EP Endpoint |
      | scenario_1      | Primary        | First Primary Objective   | Primary       | Quality of life  | PQ Endpoint |
    And the following "Scenario Schedules" exist through the Api Utility Service:
      | design scenario | schedule name | stored as  |
      | scenario_1      | Schedule 1    | schedule_1 |
    And the following "Activities" exist through the Api Utility Service:
      | design scenario | schedule   | activity                            |
      | scenario_1      | schedule_1 | ABPM, 24 Hours or More              |
      | scenario_1      | schedule_1 | Direct Coombs Test                  |
      | scenario_1      | schedule_1 | Follicle Stimulating Hormone (FSH)  |
      | scenario_1      | schedule_1 | Arterial Puncture                   |
      | scenario_1      | schedule_1 | Total Protein Except By Refractory  |
      | scenario_1      | schedule_1 | SMAC 12: 5-12 Chemistries           |
      | scenario_1      | schedule_1 | Physical Performance Test           |
      | scenario_1      | schedule_1 | Hemogram (CBC) w/ Plate & Auto Diff |
      | scenario_1      | schedule_1 | Serum Sodium                        |
      | scenario_1      | schedule_1 | Drug ID Questionnaire               |
      | scenario_1      | schedule_1 | Physicians Withdrawal Checklist     |
      | scenario_1      | schedule_1 | Fungal Culture, Other               |
      | scenario_1      | schedule_1 | Prealbumin                          |
      | scenario_1      | schedule_1 | Insulin Tolerance Test              |
      | scenario_1      | schedule_1 | Brief Neurological Exam             |
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
      | scenario_1      | schedule_1 | ABPM, 24 Hours or More              | Visit 1  |
      | scenario_1      | schedule_1 | Direct Coombs Test                  | Visit 1  |
      | scenario_1      | schedule_1 | Direct Coombs Test                  | Visit 2  |
      | scenario_1      | schedule_1 | Serum Sodium                        | Visit 3  |
      | scenario_1      | schedule_1 | ABPM, 24 Hours or More              | Visit 3  |
      | scenario_1      | schedule_1 | Direct Coombs Test                  | Visit 4  |
      | scenario_1      | schedule_1 | Follicle Stimulating Hormone (FSH)  | Visit 5  |
      | scenario_1      | schedule_1 | Arterial Puncture                   | Visit 6  |
      | scenario_1      | schedule_1 | Total Protein Except By Refractory  | Visit 7  |
      | scenario_1      | schedule_1 | SMAC 12: 5-12 Chemistries           | Visit 8  |
      | scenario_1      | schedule_1 | Physical Performance Test           | Visit 9  |
      | scenario_1      | schedule_1 | Hemogram (CBC) w/ Plate & Auto Diff | Visit 10 |
      | scenario_1      | schedule_1 | Serum Sodium                        | Visit 11 |
      | scenario_1      | schedule_1 | Drug ID Questionnaire               | Visit 12 |
      | scenario_1      | schedule_1 | Physicians Withdrawal Checklist     | Visit 13 |
      | scenario_1      | schedule_1 | Fungal Culture, Other               | Visit 14 |
      | scenario_1      | schedule_1 | Prealbumin                          | Visit 15 |
      | scenario_1      | schedule_1 | Insulin Tolerance Test              | Visit 16 |
      | scenario_1      | schedule_1 | Brief Neurological Exam             | Visit 17 |
      | scenario_1      | schedule_1 | Direct Coombs Test                  | Visit 18 |
      | scenario_1      | schedule_1 | Follicle Stimulating Hormone (FSH)  | Visit 19 |
      | scenario_1      | schedule_1 | Arterial Puncture                   | Visit 20 |
      | scenario_1      | schedule_1 | Total Protein Except By Refractory  | Visit 21 |
      | scenario_1      | schedule_1 | SMAC 12: 5-12 Chemistries           | Visit 22 |
      | scenario_1      | schedule_1 | Physical Performance Test           | Visit 23 |
      | scenario_1      | schedule_1 | Hemogram (CBC) w/ Plate & Auto Diff | Visit 24 |
    And I login to "iMedidata" as user "meditaf_09"
    And I am in Design Optimization for study group "SD_MIST104" and study "Editable References Scenario Study"


  @Release2015.2.0
  @PB143374-01
  @selenium
  @studydesign
  Scenario: Update phase for existing study/scenario/schedule and verify recalculated Per Subject Cost.
    Given in Design Optimization, I navigate to scenario "scenario_1"
    And I take a screenshot
    And in Design Optimization, the Study Identification panel contains the following data:
      | field                | value                              |
      | Protocol ID          | Editable References Scenario Study |
      | Study Name           | Editable References Scenario Study |
      | Primary Indication   | (437.1)                            |
      | Secondary Indication | (985.9)                            |
      | Phase                | Phase V                            |
    And I take a screenshot
    And in Design Optimization, I navigate to the Benchmark Analysis page
    And in Design Optimization, I verify the following phase and indication information:
      | Specificity                                | Data Volume |
      | Cerebrovascular Disease Group / All Phases | Medium      |
    And I take a screenshot
    And in Design Optimization, I navigate to the Analytics page
    And in Design Optimization, I note the current cost and complexity
    And I take a screenshot
    And I navigate to "Admin" page from "Manage Users" page
    And I navigate to "Manage Study" page from left panel side bar
    And I take a screenshot
    And I update Study with following values:
      | Phase                | Phase I                                                                                    |
      | Primary Indication   | 447.1: Other Disorders of Arteries and Arterioles, Stricture of Artery, Stenosis of Artery |
      | Secondary Indication | 429.3: Cardiomegaly: Cardiac Dilatation, Hypertrophy, Ventricular Dilatation               |
    And I take a screenshot
    And I navigate to "Editable References Scenario Study" Study in "Design Optimization" study list
    And I navigate to "Design Optimization" page from "Manage Users" page
    And in Design Optimization, I navigate to scenario "scenario_1"
    And I take a screenshot
    And in Design Optimization, the Study Identification panel contains the following data:
      | field                | value                              |
      | Protocol ID          | Editable References Scenario Study |
      | Study Name           | Editable References Scenario Study |
      | Primary Indication   | (447.1)                            |
      | Secondary Indication | (429.3)                            |
      | Phase                | Phase I                            |
    And I take a screenshot
    And in Design Optimization, I navigate to the Benchmark Analysis page
    And in Design Optimization, I verify the following phase and indication information:
      | Specificity              | Data Volume |
      | CARDIOVASCULAR / Phase I | Medium      |
    And I take a screenshot
    And in Design Optimization, I navigate to the Analytics page
    And in Design Optimization, I verify the Cost Per Subject has changed
    And in Design Optimization, I verify the Complexity Per Subject has not changed
    And I take a screenshot
    And I navigate to "Admin" page from "Manage Users" page
    And I navigate to "Manage Study" page from left panel side bar
    And I take a screenshot
    And I update Study with following values:
      | Phase                | Phase V                                                                    |
      | Primary Indication   | 437.1: Generalized Ischemic Cerebrovascular Disease, Brain Ischemia        |
      | Secondary Indication | 985.9: Poisoning, Toxic Effect of Unspecified Metal, Heavy Metal Poisoning |
    And I take a screenshot
    And I navigate to "Editable References Scenario Study" Study in "Design Optimization" study list
    And I navigate to "Design Optimization" page from "Manage Users" page
    And in Design Optimization, I navigate to scenario "scenario_1"
    And I take a screenshot
    And in Design Optimization, the Study Identification panel contains the following data:
      | field                | value                              |
      | Protocol ID          | Editable References Scenario Study |
      | Study Name           | Editable References Scenario Study |
      | Primary Indication   | (437.1)                            |
      | Secondary Indication | (985.9)                            |
      | Phase                | Phase V                            |
    And I take a screenshot
    And in Design Optimization, I navigate to the Benchmark Analysis page
    And in Design Optimization, I verify the following phase and indication information:
      | Specificity                                | Data Volume |
      | Cerebrovascular Disease Group / All Phases | Medium      |
    And I take a screenshot
    And in Design Optimization, I navigate to the Analytics page
    And in Design Optimization, I verify the Cost Per Subject has not changed
    And in Design Optimization, I verify the Complexity Per Subject has not changed
    And I take a screenshot
    And I logout from "iMedidata"

