Feature: Automation Framework Configuration Files
  In order to test the Functionality of Medidata apps end to end
  I should be able to load and access configuration files

 # Background:
 #    Given I have meditaf_config.yml file
 #    And I have other config.yml file
 #    When I initialize the Configuration
 #    Then I should have access to all Configuration items

  @SC-utils-cfg-01
  @Validation
  @Release2014.2.0
  @PBMCC-110532

  Scenario: As an integration test user I should be able to load the main configuration file
    Given I have a "main_cfg.yml" configuration file with the following values:
      | item        | value             |
      | main_item_a | main_item_a_value |
      | main_item_b | main_item_b_value |
      | main_item_c | main_item_c_value |
    When I initialize the Utils::Configuration module using the "main_cfg.yml" configuration file
    Then I verify that I have access to the configuration items
      | item        | value             |
      | main_item_a | main_item_a_value |
      | main_item_b | main_item_b_value |
      | main_item_c | main_item_c_value |


  @SC-utils-cfg-02
  @Validation
  @Release2014.2.0
  @PBMCC-110532

  Scenario: As an integration test user, I should be able to load additional configuration files
    Given I have the following configuration files
      | file          | item         | value                                       |
      | main_cfg.yml  | config_files | test_cfg1.yml, test_cfg2.yml, test_cfg3.yml |
      |               | main_item_a  | main_item_a_value                           |
      |               | main_item_b  | main_item_b_value                           |
      |               | main_item_c  | main_item_c_value                           |
      | test_cfg1.yml | cfg1_item_a  | cgf1_item_a_value                           |
      |               | cfg1_item_b  | cgf1_item_b_value                           |
      |               | cfg1_item_c  | cgf1_item_c_value                           |
      | test_cfg2.yml | cfg2_item_a  | cgf2_item_a_value                           |
      |               | cfg2_item_b  | cgf2_item_b_value                           |
      |               | cfg2_item_c  | cgf2_item_c_value                           |
      | test_cfg3.yml | cfg3_item_a  | cgf3_item_a_value                           |
      |               | cfg3_item_b  | cgf3_item_b_value                           |
      |               | cfg3_item_c  | cgf3_item_c_value                           |

    When I initialize the Utils::Configuration module using the "main_cfg.yml" configuration file
    Then I verify that I have access to the configuration items
      | item        | value             |
      | main_item_a | main_item_a_value |
      | main_item_b | main_item_b_value |
      | main_item_c | main_item_c_value |
      | cfg1_item_a | cgf1_item_a_value |
      | cfg1_item_b | cgf1_item_b_value |
      | cfg1_item_c | cgf1_item_c_value |
      | cfg2_item_a | cgf2_item_a_value |
      | cfg2_item_b | cgf2_item_b_value |
      | cfg2_item_c | cgf2_item_c_value |
      | cfg3_item_a | cgf3_item_a_value |
      | cfg3_item_b | cgf3_item_b_value |
      | cfg3_item_c | cgf3_item_c_value |

  @SC-utils-cfg-03
  @Validation
  @Release2014.2.0
  @PBMCC-110532

  Scenario: As an integration test user, I should be able to have access to a collection of configuration items
    Given I have the following configuration files
      | file          | item         | value             | item1             | value1            |
      | main_cfg.yml  | config_files | test_cfg1.yml     |                   |                   |
      |               | main_item_a  | main_item_a_value |                   |                   |
      |               | main_item_b  | main_item_b_value |                   |                   |
      |               | main_item_c  | main_item_c_value |                   |                   |
      | test_cfg1.yml | cfg1_item_a  |                   |                   |                   |
      |               |              | cfg2_item_a       | cfg2_item_a_value |                   |
      |               |              | cfg2_item_b       | cfg2_item_b_value |                   |
      |               | cfg1_item_b  | cgf1_item_b_value |                   |                   |
      |               | cfg1_item_c  |                   |                   |                   |
      |               |              | cfg2_item_a       | cfg2_item_a_value |                   |
      |               |              | cfg2_item_b       |                   |                   |
      |               |              |                   | cfg3_item_a       |                   |
      |               |              |                   |                   | cfg3_item_value_a |

    When I initialize the Utils::Configuration module using the "main_cfg.yml" configuration file
    Then I verify that I have access to the configuration items
      | item         | value             | item1             | value1            |
      | config_files | test_cfg1.yml     |                   |                   |
      | main_item_a  | main_item_a_value |                   |                   |
      | main_item_b  | main_item_b_value |                   |                   |
      | main_item_c  | main_item_c_value |                   |                   |
      | cfg1_item_a  |                   |                   |                   |
      |              | cfg2_item_a       | cfg2_item_a_value |                   |
      |              | cfg2_item_b       | cfg2_item_b_value |                   |
      | cfg1_item_b  | cgf1_item_b_value |                   |                   |
      | cfg1_item_c  |                   |                   |                   |
      |              | cfg2_item_a       | cfg2_item_a_value |                   |
      |              | cfg2_item_b       |                   |                   |
      |              |                   | cfg3_item_a       |                   |
      |              |                   |                   | cfg3_item_value_a |
