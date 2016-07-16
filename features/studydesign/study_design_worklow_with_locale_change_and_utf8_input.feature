Feature: This feature tests the cost, complexity, usage functionalities in Design Optimization.

  Background:
    Given I login to "iMedidata" as user "meditaf_09"
    And I am in Design Optimization for study group "SD_MIST104" and study "End to End Cost Analysis And Complexity"

  @Release2015.3.0
  @PB156834-01
  @selenium
  @studydesign
  @Validation
  Scenario: Add new Study, Scenario, Schedule; rename scenario and schedule; verify Activity Usage, Cost Per Subject and Complexity.
    Given I change locale to "Japanese"
    And I create a new scenario
    And I take a screenshot
    And in Design Optimization, I rename the "Active Scenario" tab to "メインシナリオ"
    And in Design Optimization, I verify the text "メインシナリオ" in the Active Scenario tab within the "Scenario Tab" bar
    And I take a screenshot
    And in Design Optimization, I toggle-open the "Study Identification" toggle-button within the "Scenario" page
    And in Design Optimization, I insert the phrase "アップデートが投稿しましたから、日本語で書かれた識別ノートを研究するために..." in the Study Design Notes input-field
    And in Design Optimization, the Study Identification panel contains the following data:
      | field                | value                                   |
      | Protocol ID          | End to End Cost Analysis And Complexity |
      | Study Name           | End to End Cost Analysis And Complexity |
      | Primary Indication   | (275.02)                                |
      | Secondary Indication | (338.12)                                |
      | Phase                | Phase II/III                            |
    And in Design Optimization, I add these new "Objectives":
      | objective type | objective description            |
      | Primary        | 日本語で主な目的説明（ ຈل͜ຈ ）ノ      |
      | Other          | 日本の☜のその他の目的の説明 ☜(`o´)   |
      | Secondary      | 日本で第二の目的の説明        ░☀▄☀░ |
    And I take a screenshot
    And in Design Optimization, I add these first "Endpoints" for the following objective(s):
      | objective type | objective description          | endpoint type | endpoint subtype | endpoint description                        |
      | Primary        | 日本語で主な目的説明（ ຈل͜ຈ ）ノ    | Exploratory   | Pharmacodynamic  | 第一の目的から日本語で最初のエンドポイントの説明   |
      | Other          | 日本の☜のその他の目的の説明 ☜(`o´) | Primary       | Pharmacokinetic  | その他の目的から日本語で最初のエンドポイントの説明 |
      | Primary        | 日本で最初の目的の説明（ ·_· ;）ノ | Tertiary      | Quality of life  | 最初の目的から、日本での最初のエンドポイントの説明 |
    And I take a screenshot
    And in Design Optimization, I create a new schedule
    And in Design Optimization, I rename the "Active Schedule" tab to "主なスケジュール"
    And in Design Optimization, I verify the text "主なスケジュール" in the Active Scenario tab within the "Scenario Tab" bar
    And I take a screenshot
    And in Design Optimization, I navigate to Activities tab
    And I take a screenshot
    And in Design Optimization, I add the following "Activities" and verify protocol usage:
      | activity name                   | code  | protocol usage |
      | Thyroid Stimulating Hormone     | 84443 | 20.85%         |
      | Molecular Diag, Interp & Report | NC161 | 4.74%          |
    And I take a screenshot
    And in Design Optimization, I navigate to Visits tab
    And in Design Optimization, I add the following "Visits":
      | encounter type     | visit type    | visit name    |
      | Visit - Outpatient | Treatment     | 第1回訪問      |
      | Phone              | Randomization | 第2回訪問      |
    And I take a screenshot
    And in Design Optimization, I navigate to Schedule Grid tab
    And I take a screenshot
    And in Design Optimization, I select the following cells:
      | activity                        | visit    |
      | Thyroid Stimulating Hormone     | 第1回訪問 |
      | Thyroid Stimulating Hormone     | 第2回訪問 |
      | Molecular Diag, Interp & Report | 第2回訪問 |
    And I take a screenshot
    And in Design Optimization, I assign purpose in Single Selection mode to the following cells:
      | activity                    | visit    | type    | subtype         | description                                 |
      | Thyroid Stimulating Hormone | 第1回訪問 | Primary | Pharmacokinetic | その他の目的から日本語で最初のエンドポイントの説明 |
    And in Design Optimization, I assign quantity & optional conditional in Single Selection mode to the following cells:
      | activity                    | visit    | minimum | optional conditional type | optional quantity | optional percentage |
      | Thyroid Stimulating Hormone | 第2回訪問 | 60      |                           |                   |                     |
    And in Design Optimization, I assign purpose in Multiple Selection mode to the following cells:
      | activity                        | visit    | type | subtype | description |
      | Thyroid Stimulating Hormone     | 第2回訪問 |      |         | Screening   |
      | Molecular Diag, Interp & Report | 第2回訪問 |      |         | Treatment   |
    And I take a screenshot
    And in Design Optimization, I verify the following data under Cost & Complexity panel:
      |                     | Minimum | Expected | Maximum  |
      | Clinical Activity   | $ 1,230 | $ 1,230  | $ 1,230  |
      | Protocol Complexity | 8.67    | 8.67     | 8.67     |
    And I take a screenshot
    And in Design Optimization, I verify the Protocol Complexity vs. Industry Benchmark chart contains the following data:
      | Title               | Protocol Complexity vs. Industry Benchmark                 |
      | Specificity & Phase | Specificity: Other Metabolic Disorders Group, Phase II/III |
      | Minimum             | 8.67                                                       |
      | Expected            | 8.67                                                       |
      | Maximum             | 8.67                                                       |
    And I take a screenshot
    And I logout from "iMedidata"
