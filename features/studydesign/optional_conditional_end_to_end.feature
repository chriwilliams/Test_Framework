Feature: As a user, I want to be able to login to Imedidata and create a study with a scenario and schedule. I want to create a schedule grid and make modifications using optional / conditional variations. Then I want to verify those changes on the Analytics and Summary Benchmarks screens.
  ----

  Background:
    Given I login to "iMedidata" as user "User1"
    And I Search for Study "SQA"
    And I click Study "SQA 2015.1.0"
    And I navigate to "Manage Study" page
    And I set Primary Indication* to "275.02 Disorders of Mineral Metabolism; Hemochromatosis Due to Repeated Red Blood Cell Transfusions
    And I set Secondary Indication to "287.49: Other Secondary Thrombocytopenia"
    And I set Phase* to "Phase IIa"
    And I navigate to "Design Optimization" page from "Manage Users" page
    And I click on the "New Scenario" tab button within the "Scenario" tab bar
    And I navigate to the Schedule page
    And I click on the "New Schedule" tab button within the "Schedule" tab bar
    And I type "blood" into the "Activity Search" input-field
    And I click on the row, whose contents contain "Brief Visit w/Vitals", under the "Name & Description" column within the "Activity Search Results" table
    And I click on the row, whose contents contain "Hemogram (CBC) w/ Plate & Auto Diff", under the "Name & Description" column within the "Activity Search Results" table
    And I click on the row, whose contents contain "SMAC 19: 13 Chemistries", under the "Name & Description" column within the "Activity Search Results" table
    And I click on the row, whose contents contain "Training on Home Monitoring Dev", under the "Name & Description" column within the "Activity Search Results" table
    And I click on the row, whose contents contain "Single Drug Level/PK; And Source", under the "Name & Description" column within the "Activity Search Results" table
    And I click on the row, whose contents contain "Home Glucose Monitoring", under the "Name & Description" column within the "Activity Search Results" table
    And I click on the row, whose contents contain "Glucose; Quantitative, Blood", under the "Name & Description" column within the "Activity Search Results" table
    And I click on the row, whose contents contain "SMAC 12: 5-12 Chemistries", under the "Name & Description" column within the "Activity Search Results" table
    And I visit the Study Visits page
    Then I change the value of the "New Visit" quantity field to "5"
    And I click on the "New Visit" button
    And I visit the Schedule Grid Page
    And the cell at 1st row 1nd column of the "Schedule Grid" table is "checked"
    And the cell at 2nd row 2nd column of the "Schedule Grid" table is "checked"
    And the cell at 3rd row 3rd column of the "Schedule Grid" table is "checked"
    And the cell at 4th row 4th column of the "Schedule Grid" table is "checked"
    And the cell at 5th row 5th column of the "Schedule Grid" table is "checked"
    And the cell at 6th row 6th column of the "Schedule Grid" table is "checked"
    And the cell at 7th row 7th column of the "Schedule Grid" table is "checked"
    And the cell at 8th row 8th column of the "Schedule Grid" table is "checked"


  @Release2015.2.0
  @PB151086-01
  @Validation
  Scenario: I see the Analytics and Benchmark and want to capture data for comparison
    When I visit the Analytics, Cost by Objective Chart Details page
    Then I should see exactly the following contents in the "Cost & Complexity" table:
      |                                         | Minimum | Expected | Maximum |
      | Clinical Activity Site Cost per Subject | $ 341   | $ 341    | $ 341   |
      | Protocol Complexity per Subject         | 1.56    | 1.56     | 1.56    |
    And the "cost by objective" pie chart has the following tooltip values on hover:
      | chart slice | value 1      | value 2  |
      | 1           | Unassociated | $ 341.00 |
    And the "Protocol Complexity vs. Industry Benchmark" chart should have the following data labels:
      | label |
      | 25.00 |
      | 32.00 |
      | 46.00 |
    When I visit the Analytics, Cost by Objective Chart Details page
    And I expand row 3 of the cost by objective details table
    And I expand row 4 of the cost by objective details table
    And I expand row 5 of the cost by objective details table
    And I expand row 6 of the cost by objective details table
    And I expand row 7 of the cost by objective details table
    And I expand row 8 of the cost by objective details table
    And I expand row 9 of the cost by objective details table
    And I expand row 10 of the cost by objective details table
    And I expand row 11 of the cost by objective details table
    Then the cost by objective details table has the following rows:
      | row | indicator | type         | description                               | quantity | cost  | percent_study_cost | complexity | percent_study_complexity |
      | 3   | expanded  | Unassociated |                                           |          | $ 341 | 100.00%            | 1.56       | 100.00%                  |
      | 4   | expanded  | Visit 1      |                                           |          | $  40 | 11.73%             | 0.18       | 11.54%                   |
      | 5   |           |              | 99211 Brief Visit w/ Vitals               | 1        | $  40 | 11.73%             | 0.18       | 11.54%                   |
      | 6   | expanded  | Visit 2      |                                           |          | $  36 | 10.56%             | 0.11       | 7.05%                    |
      | 7   |           |              | 85025 Hemogram (CBC) w/ Plate & Auto Diff | 1        | $  36 | 10.56%             | 0.11       | 7.05%                    |
      | 8   | expanded  | Visit 3      |                                           |          | $  78 | 22.87%             | 0.33       | 21.15%                   |
      | 9   |           |              | SMAC 19: 13+ Chemistries                  | 1        | $  78 | 22.87%             | 0.33       | 21.15%                   |
      | 10  | expanded  | Visit 4      |                                           |          | $  50 | 14.66%             | 0.35       | 22.44%                   |
      | 11  |           |              | TOHM Training On Home Monitoring Dev      | 1        | $  50 | 14.66%             | 0.35       | 22.44%                   |
      | 12  | expanded  | Visit 5      |                                           |          | $  30 | 8.80%              | 0.18       | 11.54%                   |
      | 13  |           |              | 80299 Single Drug Level/PK; Any Source    | 1        | $  30 | 8.80%              | 0.18       | 11.54%                   |
      | 12  | expanded  | Visit 6      |                                           |          | $  21 | 6.16%              | 0.02       | 1.28%                    |
      | 13  |           |              | 82962 Home Glucose Monitoring             | 1        | $  21 | 6.16%              | 0.02       | 1.28%                    |
      | 14  | expanded  | Visit 7      |                                           |          | $  40 | 11.73%             | 0.06       | 3.85%                    |
      | 15  |           |              | 82947 Glucose; Quantitative, Blood        | 1        | $  40 | 11.73%             | 0.06       | 3.85%                    |
      | 16  | expanded  | Visit 8      |                                           |          | $  46 | 13.49%             | 0.33       | 21.15%                   |
      | 17  |           |              | NC124 5-12 Chemistries                    | 1        | $  46 | 13.49%             | 0.33       | 21.15%                   |
    When I visit the Benchmark Analysis page
    And the "Benchmark Analysis" page is visible
    And the "Summary Benchmarks" table is visible
    Then the "Summary Benchmarks" table 1 should contain the following rows:
      | column2 | column3 | column4 | column5 | column6 | column7 |
      | 1.56    | 1.56    | 1.56    | 25      | 32      | 46      |
      | 8       | 8       | 8       | 7       | 11      | 16      |
      | 8       | 8       | 8       | 110     | 172     | 217     |
    And the "Summary Benchmarks" table 2 should contain the following rows:
      | column2 | column3 | column4 | column5 |
      | 8       | 27      | 28      | 30      |
      | N/A     | 15      | 27      | 45.57   |
    When I see the "Activity Benchmarks" table
    Then the "Activity Benchmarks" table contains the following body rows, in the following order:
      | Code  | Activities                          | Median US Cost ($) | Protocol Complexity | Protocol Usage (%) | Average Visit Quantity | Activity Quantity Range | Activity Average Quantity | Min  | Expected | Max  |
      | 99211 | Brief Visits w/Vitals               | 40                 | 0.18                | 50%                | 54                     | 1-31                    | 10                        | 1.00 | 1.00     | 1.00 |
      | 82947 | Glucose; Quantitative, Blood        | 40                 | 0.06                | 0%                 | N/A                    | N/A                     | N/A                       | 1.00 | 1.00     | 1.00 |
      | 85025 | Hemogram (CBC) w/ Plate & Auto Diff | 36                 | 0.11                | 80%                | 45                     | 4-41                    | 13                        | 1.00 | 1.00     | 1.00 |
      | 82962 | Home Glucose Monitoring             | 21                 | 0.02                | 0%                 | N/A                    | N/A                     | N/A                       | 1.00 | 1.00     | 1.00 |
      | 80299 | Single Drug Level/PK; Any Source    | 30                 | 0.18                | 80%                | 42                     | 3-35                    | 11                        | 1.00 | 1.00     | 1.00 |
      | NC124 | SMAC 12: 5-12 Chemistries           | 46                 | 0.33                | 0%                 | N/A                    | N/A                     | N/A                       | 1.00 | 1.00     | 1.00 |
      | NC125 | SMAC 19: 13+ Chemistries            | 78                 | 0.33                | 90%                | 42                     | 4-41                    | 13                        | 1.00 | 1.00     | 1.00 |
      | *TOHM | Training On Home Monitoring Dev     | 50                 | 0.35                | 0%                 | N/A                    | N/A                     | N/A                       | 1.00 | 1.00     | 1.00 |


  @Release2015.2.0
  @PB151086-02
  @Validation
  Scenario: I want to have one Visit to use each type of Optional Conditional option then verify changes on the Analytics and Benchmark Analysis pages
  --Visit 1 - Scheduled - Conditional on Procedure Result 45%
  --Visit 2 - Scheduled - Optional for Subject 25%
  --Visit 3 - Unscheduled - Early Withdrawal 75%
  --Visit 4 - Unscheduled - In Case of Adverse Event 10%
  --Visit 5 - Unscheduled - Other 5%
    Given I click the menu button in the 1st column cell of the "Study Events" header
    And I click on the "Context Optional Event" label
    And I select "Scheduled - Conditional on Procedure Result" value from the "Visit Optional Panel" dropdown
    And I change the value of the "Visit Optional Panel" percentage text to "45"
    And I click on the "Context Dialog" save button
    And I click the menu button in the 2nd column cell of the "Study Events" header
    And I click on the "Context Optional Event" label
    And I select "Scheduled - Optional for Subject" value from the "Visit Optional Panel" dropdown
    And I change the value of the "Visit Optional Panel" percentage text to "25"
    And I click on the "Context Dialog" save button
    And I click the menu button in the 3rd column cell of the "Study Events" header
    And I click on the "Context Optional Event" label
    And I select "Unscheduled - Early Withdrawal" value from the "Visit Optional Panel" dropdown
    And I change the value of the "Visit Optional Panel" percentage text to "75"
    And I click on the "Context Dialog" save button
    And I click the menu button in the 4th column cell of the "Study Events" header
    And I click on the "Context Optional Event" label
    And I select "Unscheduled - In Case of Adverse Event" value from the "Visit Optional Panel" dropdown
    And I change the value of the "Visit Optional Panel" percentage text to "10"
    And I click on the "Context Dialog" save button
    And I click the menu button in the 5th column cell of the "Study Events" header
    And I click on the "Context Optional Event" label
    And I select "Unscheduled - Other" value from the "Visit Optional Panel" dropdown
    And I change the value of the "Visit Optional Panel" percentage text to "5"
    And I click on the "Context Dialog" save button
    When I visit the Analytics, Cost by Objective Chart Details page
    Then I should see exactly the following contents in the "Cost & Complexity" table:
      |                                         | Minimum | Expected | Maximum |
      | Clinical Activity Site Cost per Subject | $ 107   | $ 199    | $ 341   |
      | Protocol Complexity per Subject         | 0.41    | 0.81     | 1.56    |
    And the "cost by objective" pie chart has the following tooltip values on hover:
      | chart slice | value 1      | value 2  |
      | 1           | Unassociated | $ 199.00 |
    And the "Protocol Complexity vs. Industry Benchmark" chart should have the following data labels:
      | label |
      | 25.00 |
      | 32.00 |
      | 46.00 |
    When I expand row 3 of the cost by objective details table
    And I expand row 4 of the cost by objective details table
    And I expand row 5 of the cost by objective details table
    And I expand row 6 of the cost by objective details table
    And I expand row 7 of the cost by objective details table
    And I expand row 8 of the cost by objective details table
    Then the cost by objective details table has the following rows:
      | row | indicator | type         | description                               | quantity | cost  | percent_study_cost | complexity | percent_study_complexity |
      | 3   | expanded  | Unassociated |                                           |          | $ 199 | 100.00%            | 0.81       | 100.00%                  |
      | 4   | expanded  | Visit 1      |                                           |          | $  18 | 9.05%              | 0.08       | 10.00%                   |
      | 5   |           |              | 99211 Brief Visit w/ Vitals               | 0.45     | $  18 | 9.05%              | 0.08       | 10.00%                   |
      | 6   | expanded  | Visit 2      |                                           |          | $  9  | 4.52%              | 0.03       | 3.40%                    |
      | 7   |           |              | 85025 Hemogram (CBC) w/ Plate & Auto Diff | 0.25     | $  9  | 4.52%              | 0.03       | 3.40%                    |
      | 8   | expanded  | Visit 3      |                                           |          | $  59 | 29.40%             | 0.25       | 30.56%                   |
      | 9   |           |              | SMAC 19: 13+ Chemistries                  | 0.75     | $  59 | 29.40%             | 0.25       | 30.56%                   |
      | 10  | expanded  | Visit 4      |                                           |          | $  5  | 2.51%              | 0.04       | 4.32%                    |
      | 11  |           |              | TOHM Training On Home Monitoring Dev      | 0.1      | $  5  | 2.51%              | 0.04       | 4.32%                    |
      | 12  | expanded  | Visit 5      |                                           |          | $  2  | 0.75%              | 0.01       | 1.11%                    |
      | 13  |           |              | 80299 Single Drug Level/PK; Any Source    | 0.05     | $  2  | 0.75%              | 0.01       | 1.11%                    |
      | 12  | expanded  | Visit 6      |                                           |          | $  21 | 10.55%             | 0.02       | 2.47%                    |
      | 13  |           |              | 82962 Home Glucose Monitoring             | 1        | $  21 | 10.55%             | 0.02       | 2.47%                    |
      | 14  | expanded  | Visit 7      |                                           |          | $  40 | 20.10%             | 0.06       | 7.41%                    |
      | 15  |           |              | 82947 Glucose; Quantitative, Blood        | 1        | $  40 | 20.10%             | 0.06       | 7.41%                    |
      | 16  | expanded  | Visit 8      |                                           |          | $  46 | 23.12%             | 0.33       | 40.74%                   |
      | 17  |           |              | NC124 5-12 Chemistries                    | 1        | $  46 | 23.12%             | 0.33       | 40.74%                   |
    When I visit the Benchmark Analysis page
    And the "Benchmark Analysis" page is visible
    And the "Summary Benchmarks" table is visible
    Then the "Summary Benchmarks" table 1 should contain the following rows:
      | column2 | column3 | column4 | column5 | column6 | column7 |
      | 0.41    | 0.81    | 1.56    | 25      | 32      | 46      |
      | 3.00    | 4.60    | 8.00    | 7       | 11      | 16      |
      | 3.00    | 4.60    | 8.00    | 110     | 172     | 217     |
    And the "Summary Benchmarks" table 2 should contain the following rows:
      | column2 | column3 | column4 | column5 |
      | 8       | 27      | 28      | 30      |
      | N/A     | 15      | 27      | 45.57   |
    When I see the "Activity Benchmarks" table
    Then the "Activity Benchmarks" table contains the following body rows, in the following order:
      | Code  | Activities                          | Median US Cost ($) | Protocol Complexity | Protocol Usage (%) | Average Visit Quantity | Activity Quantity Range | Activity Average Quantity | Min  | Expected | Max  |
      | 99211 | Brief Visits w/Vitals               | 40                 | 0.18                | 50%                | 54                     | 1-31                    | 10                        | 0.00 | 0.45     | 1.00 |
      | 82947 | Glucose; Quantitative, Blood        | 40                 | 0.06                | 0%                 | N/A                    | N/A                     | N/A                       | 1.00 | 1.00     | 1.00 |
      | 85025 | Hemogram (CBC) w/ Plate & Auto Diff | 36                 | 0.11                | 80%                | 45                     | 4-41                    | 13                        | 0.00 | 0.25     | 1.00 |
      | 82962 | Home Glucose Monitoring             | 21                 | 0.02                | 0%                 | N/A                    | N/A                     | N/A                       | 1.00 | 1.00     | 1.00 |
      | 80299 | Single Drug Level/PK; Any Source    | 30                 | 0.18                | 80%                | 42                     | 3-35                    | 11                        | 0.00 | 0.05     | 1.00 |
      | NC124 | SMAC 12: 5-12 Chemistries           | 46                 | 0.33                | 0%                 | N/A                    | N/A                     | N/A                       | 1.00 | 1.00     | 1.00 |
      | NC125 | SMAC 19: 13+ Chemistries            | 78                 | 0.33                | 90%                | 42                     | 4-41                    | 13                        | 0.00 | 0.75     | 1.00 |
      | *TOHM | Training On Home Monitoring Dev     | 50                 | 0.35                | 0%                 | N/A                    | N/A                     | N/A                       | 0.00 | 0.10     | 1.00 |


  @Release2015.2.0
  @PB151086-03
  @Validation
  Scenario: I want to have one Study Event to use each type of Optional/Conditional option with a Required Minimum Quantity and Optional/Conditional Quantity with Percentage of Subjects option then verify changes on the Analytics and Benchmark Analysis pages
  --Visit 1 / Brief Visit w/Vitals - Specified Subject Gender - Required Minimum Quantity 2 - Optional/Conditional Quantity 2 - Percentage 25%
  --Visit 2 / Hemogram (CBC) w/ Plate & Auto Diff / Specified Medical / Condition - Required Minimum Quantity 3 - Optional/Conditional Quantity 3 - Percentage 30%
  --Visit 3 / SMAC 19: 13+ Chemistries / Procedure Not Previously Performed Within Specified Time Period - Required Minimum Quantity 4 - Optional/Conditional Quantity 4 - Percentage 40%
  --Visit 4 / Training On Home Monitoring Dev / Conditional on Procedure Result / Symptom - Required Minimum Quantity 5 - Optional/Conditional Quantity 5 - Percentage 50%
  --Visit 5 / Single Drug Level/PK; Any Source / As Clinically Warranted - Required Minimum Quantity 6 - Optional/Conditional Quantity 6 - Percentage 60%
  --Visit 6 / Home Glucose Monitoring / Optional for Subject - Required Minimum Quantity 7 - Optional/Conditional Quantity 7 - Percentage 70%
  --Visit 7 / Glucose; Quantitative, Blood / Until Valid Reading Recorded - Required Minimum Quantity 8 - Optional/Conditional Quantity 8 - Percentage 80%
  --Visit 8 / SMAC 12: 5-12 Chemistries / Optional or Conditional - Other - Required Minimum Quantity 9 - Optional/Conditional Quantity 9 - Percentage 90%
    Given I click on the 1st row 1st column cell of the "Schedule Grid" table
    And I click on the arrow icon at 1st row 1st column cell of the "study cells" table
    And I click on the "Context Quantity" label
    And the "Context Dialog" quantity tab is visible
    And I select "Specified Subject Gender" optional dropdown
    And I change the value of the "Context Dialog" percentage to "25"
    And I change the value of the "Context Dialog" required / minimal quantity to "2"
    And I change the value of the "Context Dialog" optional quantity to "2"
    And I click on the "Context Dialog" save button
    And I click on the 2nd row 2nd column cell of the "Schedule Grid" table
    And I click on the arrow icon at 2nd row 2nd column cell of the "study cells" table
    And I click on the "Context Quantity" label
    And the "Context Dialog" quantity tab is visible
    And I select "Specified Medical History / Condition" optional dropdown
    And I change the value of the "Context Dialog" percentage to "30"
    And I change the value of the "Context Dialog" required / minimal quantity to "3"
    And I change the value of the "Context Dialog" optional quantity to "3"
    And I click on the "Context Dialog" save button
    And I click on the 3rd row 3rd column cell of the "Schedule Grid" table
    And I click on the arrow icon at 3rd row 3rd column cell of the "study cells" table
    And I click on the "Context Quantity" label
    And the "Context Dialog" quantity tab is visible
    And I select "Procedure Not Previously Performed Within Specified Time Period" optional dropdown
    And I change the value of the "Context Dialog" percentage to "40"
    And I change the value of the "Context Dialog" required / minimal quantity to "4"
    And I change the value of the "Context Dialog" optional quantity to "4"
    And I click on the "Context Dialog" save button
    And I click on the 4th row 4th column cell of the "Schedule Grid" table
    And I click on the arrow icon at 4th row 4th column cell of the "study cells" table
    And I click on the "Context Quantity" label
    And the "Context Dialog" quantity tab is visible
    And I select "Conditional on Procedure Result / Symptom" optional dropdown
    And I change the value of the "Context Dialog" percentage to "50"
    And I change the value of the "Context Dialog" required / minimal quantity to "5"
    And I change the value of the "Context Dialog" optional quantity to "5"
    And I click on the "Context Dialog" save button
    And I click on the 5th row 5th column cell of the "Schedule Grid" table
    And I click on the arrow icon at 5th row 5th column cell of the "study cells" table
    And I click on the "Context Quantity" label
    And the "Context Dialog" quantity tab is visible
    And I select "As Clinically Warranted" optional dropdown
    And I change the value of the "Context Dialog" percentage to "60"
    And I change the value of the "Context Dialog" required / minimal quantity to "6"
    And I change the value of the "Context Dialog" optional quantity to "6"
    And I click on the "Context Dialog" save button
    And I click on the 6th row 6th column cell of the "Schedule Grid" table
    And I click on the arrow icon at 6th row 6th column cell of the "study cells" table
    And I click on the "Context Quantity" label
    And the "Context Dialog" quantity tab is visible
    And I select "Optional for Subject" optional dropdown
    And I change the value of the "Context Dialog" percentage to "70"
    And I change the value of the "Context Dialog" required / minimal quantity to "7"
    And I change the value of the "Context Dialog" optional quantity to "7"
    And I click on the "Context Dialog" save button
    And I click on the 7th row 7th column cell of the "Schedule Grid" table
    And I click on the arrow icon at 7th row 7th column cell of the "study cells" table
    And I click on the "Context Quantity" label
    And the "Context Dialog" quantity tab is visible
    And I select "Until Valid Reading Recorded" optional dropdown
    And I change the value of the "Context Dialog" percentage to "80"
    And I change the value of the "Context Dialog" required / minimal quantity to "8"
    And I change the value of the "Context Dialog" optional quantity to "8"
    And I click on the "Context Dialog" save button
    And I click on the 8th row 8th column cell of the "Schedule Grid" table
    And I click on the arrow icon at 8th row 8th column cell of the "study cells" table
    And I click on the "Context Quantity" label
    And the "Context Dialog" quantity tab is visible
    And I select "Optional or Conditional - Other" optional dropdown
    And I change the value of the "Context Dialog" percentage to "90"
    And I change the value of the "Context Dialog" required / minimal quantity to "9"
    And I change the value of the "Context Dialog" optional quantity to "9"
    And I click on the "Context Dialog" save button
    When I visit the Analytics, Cost by Objective Chart Details page
    Then I should see exactly the following contents in the "Cost & Complexity" table:
      |                                         | Minimum | Expected | Maximum |
      | Clinical Activity Site Cost per Subject | $ 1,811 | $ 2,840  | $ 3,622 |
      | Protocol Complexity per Subject         | 8.43    | 13.04    | 16.86   |
    And the "cost by objective" pie chart has the following tooltip values on hover:
      | chart slice | value 1      | value 2    |
      | 1           | Unassociated | $ 2,840.20 |
    And the "Protocol Complexity vs. Industry Benchmark" chart should have the following data labels:
      | label |
      | 25.00 |
      | 32.00 |
      | 46.00 |
    When I expand row 3 of the cost by objective details table
    And I expand row 4 of the cost by objective details table
    And I expand row 5 of the cost by objective details table
    And I expand row 6 of the cost by objective details table
    And I expand row 7 of the cost by objective details table
    And I expand row 8 of the cost by objective details table
    Then the cost by objective details table has the following rows:
      | row | indicator | type         | description                               | quantity | cost    | percent_study_cost | complexity | percent_study_complexity |
      | 3   | expanded  | Unassociated |                                           |          | $ 2,840 | 100.00%            | 13.04      | 100.00%                  |
      | 4   | expanded  | Visit 1      |                                           |          | $  100  | 3.52%              | 0.45       | 3.45%                    |
      | 5   |           |              | 99211 Brief Visit w/ Vitals               | 2.5      | $ 100   | 3.52%              | 0.45       | 3.45%                    |
      | 6   | expanded  | Visit 2      |                                           |          | $ 140   | 4.94%              | 0.43       | 3.29%                    |
      | 7   |           |              | 85025 Hemogram (CBC) w/ Plate & Auto Diff | 3.9      | $ 140   | 4.94%              | 0.43       | 3.29%                    |
      | 8   | expanded  | Visit 3      |                                           |          | $ 437   | 15.38%             | 1.85       | 14.17%                   |
      | 9   |           |              | SMAC 19: 13+ Chemistries                  | 5.6      | $ 437   | 15.38%             | 1.85       | 14.17%                   |
      | 10  | expanded  | Visit 4      |                                           |          | $ 263   | 9.24%              | 1.84       | 14.09%                   |
      | 11  |           |              | TOHM Training On Home Monitoring Dev      | 7.25     | $ 263   | 9.24%              | 1.84       | 14.09%                   |
      | 12  | expanded  | Visit 5      |                                           |          | $ 288   | 10.14%             | 1.73       | 13.25%                   |
      | 13  |           |              | 80299 Single Drug Level/PK; Any Source    | 9.6      | $ 288   | 10.14%             | 1.73       | 13.25%                   |
      | 12  | expanded  | Visit 6      |                                           |          | $ 250   | 8.80%              | 0.24       | 1.83%                    |
      | 13  |           |              | 82962 Home Glucose Monitoring             | 11.9     | $ 250   | 8.80%              | 0.24       | 1.83%                    |
      | 14  | expanded  | Visit 7      |                                           |          | $ 576   | 20.28%             | 0.86       | 6.63%                    |
      | 15  |           |              | 82947 Glucose; Quantitative, Blood        | 14.4     | $ 576   | 20.28%             | 0.86       | 6.63%                    |
      | 16  | expanded  | Visit 8      |                                           |          | $ 787   | 27.70%             | 5.64       | 43.28%                   |
      | 17  |           |              | NC124 5-12 Chemistries                    | 17.1     | $ 787   | 27.70%             | 5.64       | 43.28%                   |
    When I visit the Benchmark Analysis page
    And the "Benchmark Analysis" page is visible
    And the "Summary Benchmarks" table is visible
    Then the "Summary Benchmarks" table 1 should contain the following rows:
      | column2 | column3 | column4 | column5 | column6 | column7 |
      | 8.43    | 13.04   | 16.86   | 25      | 32      | 46      |
      | 8.00    | 8.00    | 8.00    | 7       | 11      | 16      |
      | 44.00   | 70.50   | 88.00   | 110     | 172     | 217     |
    And the "Summary Benchmarks" table 2 should contain the following rows:
      | column2 | column3 | column4 | column5 |
      | 8       | 27      | 28      | 30      |
      | N/A     | 15      | 27      | 45.57   |
    When I see the "Activity Benchmarks" table
    Then the "Activity Benchmarks" table contains the following body rows, in the following order:
      | Code  | Activities                          | Median US Cost ($) | Protocol Complexity | Protocol Usage (%) | Average Visit Quantity | Activity Quantity Range | Activity Average Quantity | Min  | Expected | Max   |
      | 99211 | Brief Visits w/Vitals               | 40                 | 0.18                | 50%                | 54                     | 1-31                    | 10                        | 2.00 | 2.50     | 4.00  |
      | 82947 | Glucose; Quantitative, Blood        | 40                 | 0.06                | 0%                 | N/A                    | N/A                     | N/A                       | 8.00 | 14.40    | 16.00 |
      | 85025 | Hemogram (CBC) w/ Plate & Auto Diff | 36                 | 0.11                | 80%                | 45                     | 4-41                    | 13                        | 3.00 | 3.90     | 6.00  |
      | 82962 | Home Glucose Monitoring             | 21                 | 0.02                | 0%                 | N/A                    | N/A                     | N/A                       | 7.00 | 11.90    | 14.00 |
      | 80299 | Single Drug Level/PK; Any Source    | 30                 | 0.18                | 80%                | 42                     | 3-35                    | 11                        | 6.00 | 9.60     | 12.00 |
      | NC124 | SMAC 12: 5-12 Chemistries           | 46                 | 0.33                | 0%                 | N/A                    | N/A                     | N/A                       | 9.00 | 17.10    | 18.00 |
      | NC125 | SMAC 19: 13+ Chemistries            | 78                 | 0.33                | 90%                | 42                     | 4-41                    | 13                        | 4.00 | 5.60     | 8.00  |
      | *TOHM | Training On Home Monitoring Dev     | 50                 | 0.35                | 0%                 | N/A                    | N/A                     | N/A                       | 5.00 | 7.25     | 10.00 |


  @Release2015.2.0
  @PB151086-04
  @Validation
  Scenario: - I want to have one Visit to use each type of Optional Conditional option then verify changes on the Analytics and Benchmark Analysis pages
  - I want to have one Study Event to use each type of Optional/Conditional option with a Required Minimum Quantity and Optional/Conditional Quantity with Percentage of Subjects option then verify changes on the Analytics and Benchmark Analysis pages
  --Visit 1 - Scheduled - Conditional on Procedure Result 45%
  --Visit 2 - Scheduled - Optional for Subject 25%
  --Visit 3 - Unscheduled - Early Withdrawal 75%
  --Visit 4 - Unscheduled - In Case of Adverse Event 10%
  --Visit 5 - Unscheduled - Other 5%
  --Visit 1 / Brief Visit w/Vitals - Specified Subject Gender - Required Minimum Quantity 2 - Optional/Conditional Quantity 2 - Percentage 25%
  --Visit 2 / Hemogram (CBC) w/ Plate & Auto Diff / Specified Medical / Condition - Required Minimum Quantity 3 - Optional/Conditional Quantity 3 - Percentage 30%
  --Visit 3 / SMAC 19: 13+ Chemistries / Procedure Not Previously Performed Within Specified Time Period - Required Minimum Quantity 4 - Optional/Conditional Quantity 4 - Percentage 40%
  --Visit 4 / Training On Home Monitoring Dev / Conditional on Procedure Result / Symptom - Required Minimum Quantity 5 - Optional/Conditional Quantity 5 - Percentage 50%
  --Visit 5 / Single Drug Level/PK; Any Source / As Clinically Warranted - Required Minimum Quantity 6 - Optional/Conditional Quantity 6 - Percentage 60%
  --Visit 6 / Home Glucose Monitoring / Optional for Subject - Required Minimum Quantity 7 - Optional/Conditional Quantity 7 - Percentage 70%
  --Visit 7 / Glucose; Quantitative, Blood / Until Valid Reading Recorded - Required Minimum Quantity 8 - Optional/Conditional Quantity 8 - Percentage 80%
  --Visit 8 / SMAC 12: 5-12 Chemistries / Optional or Conditional - Other - Required Minimum Quantity 9 - Optional/Conditional Quantity 9 - Percentage 90%
    Given I click the menu button in the 1st column cell of the "Study Events" header
    And I click on the "Context Optional Event" label
    And I select "Scheduled - Conditional on Procedure Result" value from the "Visit Optional Panel" dropdown
    And I change the value of the "Visit Optional Panel" percentage text to "45"
    And I click on the "Context Dialog" save button
    And I click the menu button in the 2nd column cell of the "Study Events" header
    And I click on the "Context Optional Event" label
    And I select "Scheduled - Optional for Subject" value from the "Visit Optional Panel" dropdown
    And I change the value of the "Visit Optional Panel" percentage text to "25"
    And I click on the "Context Dialog" save button
    And I click the menu button in the 3rd column cell of the "Study Events" header
    And I click on the "Context Optional Event" label
    And I select "Unscheduled - Early Withdrawal" value from the "Visit Optional Panel" dropdown
    And I change the value of the "Visit Optional Panel" percentage text to "75"
    And I click on the "Context Dialog" save button
    And I click the menu button in the 4th column cell of the "Study Events" header
    And I click on the "Context Optional Event" label
    And I select "Unscheduled - In Case of Adverse Event" value from the "Visit Optional Panel" dropdown
    And I change the value of the "Visit Optional Panel" percentage text to "10"
    And I click on the "Context Dialog" save button
    And I click the menu button in the 5th column cell of the "Study Events" header
    And I click on the "Context Optional Event" label
    And I select "Unscheduled - Other" value from the "Visit Optional Panel" dropdown
    And I change the value of the "Visit Optional Panel" percentage text to "5"
    And I click on the "Context Dialog" save button
    And I visit the Analytics, Cost by Objective Chart Details page
    And I should see exactly the following contents in the "Cost & Complexity" table:
    And I click on the 1st row 1st column cell of the "Schedule Grid" table
    And I click on the arrow icon at 1st row 1st column cell of the "study cells" table
    And I click on the "Context Quantity" label
    And the "Context Dialog" quantity tab is visible
    And I select "Specified Subject Gender" optional dropdown
    And I change the value of the "Context Dialog" percentage to "25"
    And I change the value of the "Context Dialog" required / minimal quantity to "2"
    And I change the value of the "Context Dialog" optional quantity to "2"
    And I click on the "Context Dialog" save button
    And I click on the 2nd row 2nd column cell of the "Schedule Grid" table
    And I click on the arrow icon at 2nd row 2nd column cell of the "study cells" table
    And I click on the "Context Quantity" label
    And the "Context Dialog" quantity tab is visible
    And I select "Specified Medical History / Condition" optional dropdown
    And I change the value of the "Context Dialog" percentage to "30"
    And I change the value of the "Context Dialog" required / minimal quantity to "3"
    And I change the value of the "Context Dialog" optional quantity to "3"
    And I click on the "Context Dialog" save button
    And I click on the 3rd row 3rd column cell of the "Schedule Grid" table
    And I click on the arrow icon at 3rd row 3rd column cell of the "study cells" table
    And I click on the "Context Quantity" label
    And the "Context Dialog" quantity tab is visible
    And I select "Procedure Not Previously Performed Within Specified Time Period" optional dropdown
    And I change the value of the "Context Dialog" percentage to "40"
    And I change the value of the "Context Dialog" required / minimal quantity to "4"
    And I change the value of the "Context Dialog" optional quantity to "4"
    And I click on the "Context Dialog" save button
    And I click on the 4th row 4th column cell of the "Schedule Grid" table
    And I click on the arrow icon at 4th row 4th column cell of the "study cells" table
    And I click on the "Context Quantity" label
    And the "Context Dialog" quantity tab is visible
    And I select "Conditional on Procedure Result / Symptom" optional dropdown
    And I change the value of the "Context Dialog" percentage to "50"
    And I change the value of the "Context Dialog" required / minimal quantity to "5"
    And I change the value of the "Context Dialog" optional quantity to "5"
    And I click on the "Context Dialog" save button
    And I click on the 5th row 5th column cell of the "Schedule Grid" table
    And I click on the arrow icon at 5th row 5th column cell of the "study cells" table
    And I click on the "Context Quantity" label
    And the "Context Dialog" quantity tab is visible
    And I select "As Clinically Warranted" optional dropdown
    And I change the value of the "Context Dialog" percentage to "60"
    And I change the value of the "Context Dialog" required / minimal quantity to "6"
    And I change the value of the "Context Dialog" optional quantity to "6"
    And I click on the "Context Dialog" save button
    And I click on the 6th row 6th column cell of the "Schedule Grid" table
    And I click on the arrow icon at 6th row 6th column cell of the "study cells" table
    And I click on the "Context Quantity" label
    And the "Context Dialog" quantity tab is visible
    And I select "Optional for Subject" optional dropdown
    And I change the value of the "Context Dialog" percentage to "70"
    And I change the value of the "Context Dialog" required / minimal quantity to "7"
    And I change the value of the "Context Dialog" optional quantity to "7"
    And I click on the "Context Dialog" save button
    And I click on the 7th row 7th column cell of the "Schedule Grid" table
    And I click on the arrow icon at 7th row 7th column cell of the "study cells" table
    And I click on the "Context Quantity" label
    And the "Context Dialog" quantity tab is visible
    And I select "Until Valid Reading Recorded" optional dropdown
    And I change the value of the "Context Dialog" percentage to "80"
    And I change the value of the "Context Dialog" required / minimal quantity to "8"
    And I change the value of the "Context Dialog" optional quantity to "8"
    And I click on the "Context Dialog" save button
    And I click on the 8th row 8th column cell of the "Schedule Grid" table
    And I click on the arrow icon at 8th row 8th column cell of the "study cells" table
    And I click on the "Context Quantity" label
    And the "Context Dialog" quantity tab is visible
    And I select "Optional or Conditional - Other" optional dropdown
    And I change the value of the "Context Dialog" percentage to "90"
    And I change the value of the "Context Dialog" required / minimal quantity to "9"
    And I change the value of the "Context Dialog" optional quantity to "9"
    And I click on the "Context Dialog" save button
    When I visit the Analytics, Cost by Objective Chart Details page
    Then I should see exactly the following contents in the "Cost & Complexity" table:
      |                                         | Minimum | Expected | Maximum |
      | Clinical Activity Site Cost per Subject | $ 881   | $ 2,061  | $ 3,622 |
      | Protocol Complexity per Subject         | 3.59    | 8.71     | 16.86   |
    And the "cost by objective" pie chart has the following tooltip values on hover:
      | chart slice | value 1      | value 2    |
      | 1           | Unassociated | $ 2,061.85 |
    And the "Protocol Complexity vs. Industry Benchmark" chart should have the following data labels:
      | label |
      | 25.00 |
      | 32.00 |
      | 46.00 |
    When I expand row 3 of the cost by objective details table
    And I expand row 4 of the cost by objective details table
    And I expand row 5 of the cost by objective details table
    And I expand row 6 of the cost by objective details table
    And I expand row 7 of the cost by objective details table
    And I expand row 8 of the cost by objective details table
    Then the cost by objective details table has the following rows:
      | row | indicator | type         | description                               | quantity | cost    | percent_study_cost | complexity | percent_study_complexity |
      | 3   | expanded  | Unassociated |                                           |          | $ 2,061 | 100.00%            | 8.71       | 100.00%                  |
      | 4   | expanded  | Visit 1      |                                           |          | $ 45    | 2.18%              | 0.20       | 2.32%                    |
      | 5   |           |              | 99211 Brief Visit w/ Vitals               | 1.125    | $ 45    | 2.18%              | 0.20       | 2.32%                    |
      | 6   | expanded  | Visit 2      |                                           |          | $ 35    | 1.70%              | 0.11       | 1.23%                    |
      | 7   |           |              | 85025 Hemogram (CBC) w/ Plate & Auto Diff | 0.975    | $ 35    | 1.70%              | 0.11       | 1.23%                    |
      | 8   | expanded  | Visit 3      |                                           |          | $ 328   | 15.90%             | 1.39       | 15.19%                   |
      | 9   |           |              | SMAC 19: 13+ Chemistries                  | 4.2      | $ 328   | 15.90%             | 1.39       | 15.19%                   |
      | 10  | expanded  | Visit 4      |                                           |          | $ 26    | 1.27%              | 0.18       | 2.11%                    |
      | 11  |           |              | TOHM Training On Home Monitoring Dev      | 0.525    | $ 26    | 1.27%              | 0.18       | 2.11%                    |
      | 12  | expanded  | Visit 5      |                                           |          | $ 14    | 0.70%              | 0.09       | 0.99%                    |
      | 13  |           |              | 80299 Single Drug Level/PK; Any Source    | 0.48     | $ 14    | 0.70%              | 0.09       | 0.99%                    |
      | 12  | expanded  | Visit 6      |                                           |          | $ 250   | 12.23%             | 0.24       | 2.73%                    |
      | 13  |           |              | 82962 Home Glucose Monitoring             | 11.9     | $ 250   | 12.23%             | 0.24       | 2.73%                    |
      | 14  | expanded  | Visit 7      |                                           |          | $ 576   | 27.95%             | 0.86       | 9.92%                    |
      | 15  |           |              | 82947 Glucose; Quantitative, Blood        | 14.4     | $ 576   | 27.95%             | 0.86       | 9.92%                    |
      | 16  | expanded  | Visit 8      |                                           |          | $ 787   | 38.17%             | 5.64       | 64.78%                   |
      | 17  |           |              | NC124 5-12 Chemistries                    | 17.1     | $ 787   | 38.17%             | 5.64       | 64.78%                   |
    When I visit the Benchmark Analysis page
    And the "Benchmark Analysis" page is visible
    And the "Summary Benchmarks" table is visible
    Then the "Summary Benchmarks" table 1 should contain the following rows:
      | column2 | column3 | column4 | column5 | column6 | column7 |
      | 3.59    | 8.71    | 16.86   | 25      | 32      | 46      |
      | 3.00    | 4.60    | 8.00    | 7       | 11      | 16      |
      | 24.00   | 50.93   | 88.00   | 110     | 172     | 217     |
    And the "Summary Benchmarks" table 2 should contain the following rows:
      | column2 | column3 | column4 | column5 |
      | 8       | 27      | 28      | 30      |
      | N/A     | 15      | 27      | 45.57   |
    When I see the "Activity Benchmarks" table
    Then the "Activity Benchmarks" table contains the following body rows, in the following order:
      | Code  | Activities                          | Median US Cost ($) | Protocol Complexity | Protocol Usage (%) | Average Visit Quantity | Activity Quantity Range | Activity Average Quantity | Min  | Expected | Max   |
      | 99211 | Brief Visits w/Vitals               | 40                 | 0.18                | 50%                | 54                     | 1-31                    | 10                        | 0.00 | 1.13     | 4.00  |
      | 82947 | Glucose; Quantitative, Blood        | 40                 | 0.06                | 0%                 | N/A                    | N/A                     | N/A                       | 8.00 | 14.40    | 16.00 |
      | 85025 | Hemogram (CBC) w/ Plate & Auto Diff | 36                 | 0.11                | 80%                | 45                     | 4-41                    | 13                        | 0.00 | 0.98     | 6.00  |
      | 82962 | Home Glucose Monitoring             | 21                 | 0.02                | 0%                 | N/A                    | N/A                     | N/A                       | 7.00 | 11.90    | 14.00 |
      | 80299 | Single Drug Level/PK; Any Source    | 30                 | 0.18                | 80%                | 42                     | 3-35                    | 11                        | 0.00 | 0.48     | 12.00 |
      | NC124 | SMAC 12: 5-12 Chemistries           | 46                 | 0.33                | 0%                 | N/A                    | N/A                     | N/A                       | 9.00 | 17.10    | 18.00 |
      | NC125 | SMAC 19: 13+ Chemistries            | 78                 | 0.33                | 90%                | 42                     | 4-41                    | 13                        | 0.00 | 4.20     | 8.00  |
      | *TOHM | Training On Home Monitoring Dev     | 50                 | 0.35                | 0%                 | N/A                    | N/A                     | N/A                       | 0.00 | 0.75     | 10.00 |


