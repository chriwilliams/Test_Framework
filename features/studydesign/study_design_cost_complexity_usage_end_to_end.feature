Feature: This feature tests the cost, complexity, usage functionalities in Design Optimization.

  Background:
    Given I login to "iMedidata" as user "meditaf_09"
    And I am in Design Optimization for study group "SD_MIST104" and study "End to End Cost Analysis And Complexity"

  @Release2015.2.0
  @PB137152-01
  @selenium
  @studydesign
  @Validation
  Scenario: Add new Study, Scenario, Schedule(multiple schedules); rename scenario and schedule; verify Activity Usage, Cost Per Subject and Complexity; delete schedule and scenario.
    Given I create a new scenario
    And I take a screenshot
    And in Design Optimization, I rename the "Active Scenario" tab to "Main Scenario"
    And in Design Optimization, I note the "Active Scenario" tab as "scenario_1"
    And I take a screenshot
    And in Design Optimization, the Study Identification panel contains the following data:
      | field                | value                                   |
      | Protocol ID          | End to End Cost Analysis And Complexity |
      | Study Name           | End to End Cost Analysis And Complexity |
      | Primary Indication   | (275.02)                                |
      | Secondary Indication | (338.12)                                |
      | Phase                | Phase II/III                            |
    And I take a screenshot
    And in Design Optimization, I toggle-close the "Study Identification" toggle-button within the "Scenario" page
    And in Design Optimization, I add the first "Objective":
      | objective type | objective description |
      | Primary        | first objective desc  |
    And in Design Optimization, I add these new "Objectives":
      | objective type | objective description  |
      | Primary        | new p1. objective desc |
      | Other          | new o1. objective desc |
      | Secondary      | new s1. objective desc |
      | Tertiary       | new t1. objective desc |
      | Primary        | new p2. objective desc |
      | Other          | new o2. objective desc |
    And I take a screenshot
    And in Design Optimization, I add these first "Endpoints" for the following objective(s):
      | objective type | objective description  | endpoint type | endpoint subtype | endpoint description |
      | Primary        | new p1. objective desc | Exploratory   | Pharmacodynamic  | ep endpoint1         |
      | Other          | new o1. objective desc | Primary       | Pharmacokinetic  | pp endpoint1         |
      | Secondary      | new s1. objective desc | Exploratory   | Safety           | es endpoint1         |
      | Tertiary       | new t1. objective desc | Secondary     | Other            | so endpoint1         |
      | Primary        | new p2. objective desc | Tertiary      | Quality of life  | tq endpoint1         |
    And in Design Optimization, I add these new "Endpoints" for the following objective(s):
      | objective type | objective description  | endpoint type | endpoint subtype | endpoint description |
      | Primary        | new p1. objective desc | Tertiary      | Efficacy         | te endpoint2         |
      | Other          | new o1. objective desc | Exploratory   | Quality of life  | eq endpoint2         |
      | Secondary      | new s1. objective desc | Exploratory   | Efficacy         | ee endpoint2         |
      | Tertiary       | new t1. objective desc | Secondary     | Pharmacokinetic  | sp endpoint2         |
      | Primary        | new p2. objective desc | Tertiary      | Pharmacoeconomic | tp endpoint3         |
      | Primary        | new p2. objective desc | Other         | Quality of life  | oq endpoint4         |
    And I take a screenshot
    And in Design Optimization, I create a new schedule
    And in Design Optimization, I rename the "Active Schedule" tab to "Main Schedule"
    And in Design Optimization, I note Active Schedule name as "schedule_1"
    And I take a screenshot
    And in Design Optimization, I create a new schedule
    And in Design Optimization, I rename the "Active Schedule" tab to "Second Schedule"
    And in Design Optimization, I note Active Schedule name as "schedule_2"
    And I take a screenshot
    And in Design Optimization, I navigate to the Analytics page for schedule: "schedule_2"
    And in Design Optimization, I verify the following data under Cost & Complexity panel:
      |                     | Minimum | Expected | Maximum |
      | Clinical Activity   | $ 0     | $ 0      | $ 0     |
      | Protocol Complexity | 0.00    | 0.00     | 0.00    |
    And I take a screenshot
    And in Design Optimization, I verify the Protocol Complexity vs. Industry Benchmark chart contains the following data:
      | Title               | Protocol Complexity vs. Industry Benchmark                 |
      | Specificity & Phase | Specificity: Other Metabolic Disorders Group, Phase II/III |
      | Minimum             | 0.00                                                       |
      | Expected            | 0.00                                                       |
      | Maximum             | 0.00                                                       |
    And in Design Optimization, I verify the following legends are present within the pie chart:
      | Legends             |
      | Primary Objective   |
      | Secondary Objective |
      | Tertiary Objective  |
      | Other Objective     |
      | Unassociated        |
    And I take a screenshot
    And in Design Optimization, I open the View Chart Details table section
    And in Design Optimization, I verify these total values within the View Chart Details table:
      | Type   | Quantity | Clinical Activity Site Cost per Subject | Protocol Complexity |
      | Totals | 0        | $ 0                                     | 0.00                |
    And I take a screenshot
    And in Design Optimization, I close the View Chart Details table section
    And I take a screenshot
    And in Design Optimization, I navigate to the Schedule page for schedule: "schedule_1"
    And in Design Optimization, I navigate to Activities tab
    And I take a screenshot
    And in Design Optimization, I add the following "Activities" and verify protocol usage:
      | activity name                      | code  | protocol usage |
      | Thyroid Stimulating Hormone        | 84443 | 20.85%         |
      | Molecular Diag, Interp & Report    | NC161 | 4.74%          |
      | Follicle Stimulating Hormone (FSH) | 83001 | 22.27%         |
      | Brief Pain Inventory Short Form    | *BPIS | 2.84%          |
      | Human Growth Hormone Antibody      | 86277 | 0.95%          |
      | Human Growth Hormone Antibody      | 86277 | 0.95%          |
      | Qualitative Syphilis Test          | 86592 | 0.47%          |
      | Isol. Highly Purified Nucleic Acid | NC147 | 4.74%          |
      | PCR, Each Nucleic Acid Sequence    | NC152 | 4.74%          |
      | Review Concomitant Medications     | *RCM* | 98.58%         |
      | SMAC 12: 5-12 Chemistries          | NC124 | 31.28%         |
      | Creatinine; Blood                  | 82565 | 10.90%         |
      | Alkaline Phosphatase (ALP)         | 84075 | 9.48%          |
    And in Design Optimization, I navigate to Visits tab
    And in Design Optimization, I add the following "Visits":
      | encounter type     | visit type    | visit name |
      | Visit - Outpatient | Treatment     | Visit 1    |
      | Phone              | Randomization | Visit 2    |
      | Other              | Randomization | Visit 3    |
      | Visit - Outpatient | Extension     | Visit 4    |
      | Visit - Outpatient | Treatment     | Visit 5    |
      | Phone              | Randomization | Visit 6    |
      | Other              | Randomization | Visit 7    |
      | Visit - Outpatient | Extension     | Visit 8    |
      | Visit - Outpatient | Screening     | Visit 9    |
      | Phone              | Screening     | Visit 10   |
      | Other              | Screening     | Visit 11   |
      | Visit - Outpatient | Screening     | Visit 12   |
    And in Design Optimization, I navigate to Schedule Grid tab
    And I take a screenshot
    And in Design Optimization, I select the following cells:
      | activity                           | visit    |
      | Thyroid Stimulating Hormone        | Visit 1  |
      | Thyroid Stimulating Hormone        | Visit 2  |
      | Thyroid Stimulating Hormone        | Visit 4  |
      | Thyroid Stimulating Hormone        | Visit 7  |
      | Thyroid Stimulating Hormone        | Visit 8  |
      | Thyroid Stimulating Hormone        | Visit 10 |
      | Thyroid Stimulating Hormone        | Visit 11 |
      | Thyroid Stimulating Hormone        | Visit 12 |
      | Molecular Diag, Interp & Report    | Visit 2  |
      | Molecular Diag, Interp & Report    | Visit 3  |
      | Molecular Diag, Interp & Report    | Visit 6  |
      | Molecular Diag, Interp & Report    | Visit 9  |
      | Molecular Diag, Interp & Report    | Visit 11 |
      | Follicle Stimulating Hormone (FSH) | Visit 2  |
      | Follicle Stimulating Hormone (FSH) | Visit 4  |
      | Follicle Stimulating Hormone (FSH) | Visit 5  |
      | Follicle Stimulating Hormone (FSH) | Visit 7  |
      | Follicle Stimulating Hormone (FSH) | Visit 8  |
      | Follicle Stimulating Hormone (FSH) | Visit 9  |
      | Follicle Stimulating Hormone (FSH) | Visit 12 |
      | Brief Pain Inventory Short Form    | Visit 1  |
      | Brief Pain Inventory Short Form    | Visit 3  |
      | Brief Pain Inventory Short Form    | Visit 5  |
      | Brief Pain Inventory Short Form    | Visit 9  |
      | Human Growth Hormone Antibody      | Visit 3  |
      | Human Growth Hormone Antibody      | Visit 6  |
      | Human Growth Hormone Antibody      | Visit 9  |
      | Human Growth Hormone Antibody      | Visit 11 |
      | Human Growth Hormone Antibody      | Visit 12 |
      | Human Growth Hormone Antibody >[2] | Visit 2  |
      | Human Growth Hormone Antibody >[2] | Visit 4  |
      | Human Growth Hormone Antibody >[2] | Visit 8  |
      | Human Growth Hormone Antibody >[2] | Visit 9  |
      | Qualitative Syphilis Test          | Visit 1  |
      | Qualitative Syphilis Test          | Visit 3  |
      | Qualitative Syphilis Test          | Visit 4  |
      | Qualitative Syphilis Test          | Visit 11 |
      | Qualitative Syphilis Test          | Visit 12 |
      | Isol. Highly Purified Nucleic Acid | Visit 2  |
      | Isol. Highly Purified Nucleic Acid | Visit 7  |
      | Isol. Highly Purified Nucleic Acid | Visit 9  |
      | Isol. Highly Purified Nucleic Acid | Visit 10 |
      | PCR, Each Nucleic Acid Sequence    | Visit 1  |
      | PCR, Each Nucleic Acid Sequence    | Visit 5  |
      | Alkaline Phosphatase (ALP)         | Visit 7  |
      | Alkaline Phosphatase (ALP)         | Visit 9  |
      | Alkaline Phosphatase (ALP)         | Visit 11 |
    And I take a screenshot
    And in Design Optimization, I assign purpose in Single Selection mode to the following cells:
      | activity                           | visit    | type        | subtype         | description  |
      | Thyroid Stimulating Hormone        | Visit 1  | Exploratory | Pharmacodynamic | ep endpoint1 |
      | Human Growth Hormone Antibody      | Visit 9  | Other       | Quality of life | oq endpoint4 |
      | Qualitative Syphilis Test          | Visit 12 | Exploratory | Safety          | es endpoint1 |
      | Isol. Highly Purified Nucleic Acid | Visit 10 | Exploratory | Efficacy        | ee endpoint2 |
      | Human Growth Hormone Antibody >[2] | Visit 2  |             |                 | Screening    |
    And in Design Optimization, I assign quantity & optional conditional in Single Selection mode to the following cells:
      | activity                        | visit    | minimum | optional conditional type             | optional quantity | optional percentage |
      | Thyroid Stimulating Hormone     | Visit 8  | 60      |                                       |                   |                     |
      | Brief Pain Inventory Short Form | Visit 5  |         | Specified Medical History / Condition | 75                | 95                  |
      | Alkaline Phosphatase (ALP)      | Visit 11 |         | As Clinically Warranted               | 55                |                     |
      | Qualitative Syphilis Test       | Visit 12 |         | Optional or Conditional - Other       |                   | 80                  |
    And in Design Optimization, I assign purpose in Multiple Selection mode to the following cells:
      | activity                           | visit    | type        | subtype         | description  |
      | Thyroid Stimulating Hormone        | Visit 1  |             |                 | Screening    |
      | Molecular Diag, Interp & Report    | Visit 3  |             |                 | Treatment    |
      | Follicle Stimulating Hormone (FSH) | Visit 5  | Exploratory | Efficacy        | ee endpoint2 |
      | Brief Pain Inventory Short Form    | Visit 7  | Other       | Quality of life | oq endpoint4 |
      | Human Growth Hormone Antibody      | Visit 11 |             |                 |              |
      | Alkaline Phosphatase (ALP)         | Visit 1  |             |                 |              |
      | Qualitative Syphilis Test          | Visit 1  |             |                 |              |
      | Isol. Highly Purified Nucleic Acid | Visit 2  |             |                 |              |
    And in Design Optimization, I assign quantity & optional conditional in Single Selection mode to the following cells:
      | activity                           | visit   | minimum | optional conditional type    | optional quantity | optional percentage |
      | Thyroid Stimulating Hormone        | Visit 1 | 60      |                              |                   |                     |
      | Brief Pain Inventory Short Form    | Visit 9 |         | Specified Subject Gender     | 80                | 85                  |
      | Isol. Highly Purified Nucleic Acid | Visit 2 |         | Until Valid Reading Recorded | 70                |                     |
    And in Design Optimization, I navigate to the Analytics page for schedule: "schedule_1"
    And in Design Optimization, I verify the following data under Cost & Complexity panel:
      |                     | Minimum | Expected | Maximum  |
      | Clinical Activity   | $ 4,404 | $ 9,944  | $ 12,264 |
      | Protocol Complexity | 23.28   | 48.65    | 55.47    |
    And I take a screenshot
    And in Design Optimization, I verify the Protocol Complexity vs. Industry Benchmark chart contains the following data:
      | Title               | Protocol Complexity vs. Industry Benchmark                 |
      | Specificity & Phase | Specificity: Other Metabolic Disorders Group, Phase II/III |
      | Minimum             | 23.28                                                      |
      | Expected            | 48.65                                                      |
      | Maximum             | 55.47                                                      |
    And in Design Optimization, I verify the pie chart is present for the "Expected Activity Cost by Objective Type" chart
    And in Design Optimization, I verify the following legends are present within the pie chart:
      | Legends             |
      | Primary Objective   |
      | Secondary Objective |
      | Tertiary Objective  |
      | Other Objective     |
      | Screening           |
      | Treatment           |
      | Unassociated        |
    And I take a screenshot
    And in Design Optimization, I open the View Chart Details table section
    And in Design Optimization, I verify these total values within the View Chart Details table:
      | Type   | Quantity | Clinical Activity Site Cost per Subject | Protocol Complexity |
      | Totals | 364.55   | $ 9,944                                | 48.65              |
    And I take a screenshot
    And in Design Optimization, I navigate to the Benchmark Analysis page for schedule: "schedule_1"
    And I take a screenshot
    And in Design Optimization, I verify the following phase and indication information:
      | Specificity                                    | Data Volume |
      | Other Metabolic Disorders Group / Phase II/III | Medium      |
    And in Design Optimization, I verify the following tables are visible:
      | table                   |
      | Top Summary Benchmark   |
      | Lower Summary Benchmark |
      | Activity Benchmark      |
    And I logout from "iMedidata"
